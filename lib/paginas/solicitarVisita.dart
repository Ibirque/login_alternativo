import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importar este paquete para formatear la fecha

import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/my_button.dart';

class SolicitarVisita extends StatefulWidget {
  const SolicitarVisita({Key? key}) : super(key: key);

  @override
  _SolicitarVisitaState createState() => _SolicitarVisitaState();
}

class _SolicitarVisitaState extends State<SolicitarVisita> {
  TextEditingController ciudadController = TextEditingController();
  TextEditingController diaController = TextEditingController();
  TextEditingController doctorController = TextEditingController();
  TextEditingController horaController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController notasController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  int _currentIndex = 2;

  // Dropdown de ciudades
  List<String> ciudadesDisponibles = ['Barcelona', 'Madrid', 'Zaragoza'];
  String? ciudadSeleccionada;

  // Dropdown de tipos de visita
  List<String> tiposVisita = ['Primera visita', 'Urgencias'];
  String? tipoVisitaSeleccionada;

  // Doctor seleccionado
  String? doctorSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'lib/assets/logo_white.png',
          width: 200,
          height: 80,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    // Selector de ciudad
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ciudad',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: ciudadSeleccionada,
                      onChanged: (newValue) {
                        setState(() {
                          ciudadSeleccionada = newValue!;
                        });
                      },
                      items: ciudadesDisponibles.map((ciudad) {
                        return DropdownMenuItem<String>(
                          value: ciudad,
                          child: Text(ciudad),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    // Selector de tipo de visita
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Tipo de visita',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: tipoVisitaSeleccionada,
                      onChanged: (newValue) {
                        setState(() {
                          tipoVisitaSeleccionada = newValue!;
                        });
                      },
                      items: tiposVisita.map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(tipo),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    // Selector de fecha
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: diaController,
                      readOnly: true,
                      onTap: () {
                        _selectDate(
                            context); // Llamar al método para seleccionar la fecha
                      },
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Día',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: horaController,
                    hintText: 'Hora',
                    obscureText: false,
                  ),
                  MyTextField(
                    controller: hospitalController,
                    hintText: 'Centro de salud',
                    obscureText: false,
                  ),
                  Container(
                    // Selector de doctor
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('doctores').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error al cargar los datos');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        List<DropdownMenuItem<String>> items = [];
                        snapshot.data!.docs.forEach((doc) {
                          String nombreDoctor = doc['nombre'];
                          items.add(DropdownMenuItem<String>(
                            value: nombreDoctor,
                            child: Text(nombreDoctor),
                          ));
                        });

                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Doctor',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          value: doctorSeleccionado,
                          onChanged: (newValue) {
                            setState(() {
                              doctorSeleccionado = newValue!;
                            });
                          },
                          items: items,
                        );
                      },
                    ),
                  ),
                  MyTextField(
                    controller: notasController,
                    hintText: 'Motivo de la visita',
                    obscureText: false,
                  ),
                  MyButton(
                    onPressed: _guardarSolicitud,
                    buttonText: 'Guardar Solicitud',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Dependiendo del índice seleccionado, navegamos a la página correspondiente
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(index);
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != diaController.text) {
      setState(() {
        diaController.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Formatear la fecha seleccionada
      });
    }
  }

  Future<void> _guardarSolicitud() async {
    try {
      // Obtener los datos de la solicitud de visita
      String ciudad = ciudadController.text;
      String dia = diaController.text;
      String doctor = doctorSeleccionado ?? ''; // Usamos el doctor seleccionado
      String hora = horaController.text;
      String hospital = hospitalController.text;
      String notas = notasController.text;
      String tipo = tipoController.text;

      // Guardar los datos en Firebase
      await FirebaseFirestore.instance.collection('solicitudesDeVisita').add({
        'ciudad': ciudad,
        'dia': dia,
        'doctor': doctor,
        'hora': hora,
        'hospital': hospital,
        'notas': notas,
        'tipo': tipo,
      });

      // Notificar al usuario sobre el éxito de la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Solicitud de visita guardada exitosamente')),
      );
    } catch (e) {
      // Manejar cualquier error y notificar al usuario sobre el fallo de la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al guardar la solicitud de visita')),
      );
    }
  }
}
