import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/my_button.dart';

//Selectores
import 'package:login_alternativo/componentes/selector_Doctor.dart';
import 'package:login_alternativo/componentes/selector_Dia.dart';
import 'package:login_alternativo/componentes/selector_Horario.dart'; 
import 'package:login_alternativo/componentes/selector_Fecha.dart'; 

class SolicitarVisita extends StatefulWidget {
  const SolicitarVisita({Key? key}) : super(key: key);

  @override
  _SolicitarVisitaState createState() => _SolicitarVisitaState();
}

class _SolicitarVisitaState extends State<SolicitarVisita> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController ciudadController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController notasController = TextEditingController();
  int _currentIndex = 2;

  //Dropdowns
  // Dropdown de ciudades
  List<String> ciudadesDisponibles = ['Barcelona', 'Madrid', 'Zaragoza'];
  String? ciudadSeleccionada;
  String? doctorId;
  // Dropdown de tipos de visita
  List<String> tiposVisita = ['Primera visita', 'Urgencias'];
  String? tipoVisitaSeleccionada;


  //Selectores
  // Doctor seleccionado
  String? doctorSeleccionado;
  // Horarios seleccionados
  List<String>? horariosSeleccionados;
  // Días de trabajo seleccionados
  String? diaTrabajoSeleccionado;
  // Fecha seleccionada
  DateTime? _fechaSeleccionada;

  TextEditingController diaController =
      TextEditingController(); // Nuevo controlador para la fecha

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

                  // Separador
                  const SizedBox(height: 20),

                  // Utilizando el DoctorSelector
                  DoctorSelector(
                    onChanged: (doctorData) {
                      setState(() {
                        doctorSeleccionado = doctorData['nombre'];
                        doctorId = doctorData['id'];
                        // Mandar la ID del doctor a HorariosVisita
                        // Lógica para enviar la ID a HorariosVisita
                      });
                    },
                  ),

                  // Separador
                  const SizedBox(height: 20),

                  // Utilizando DiaTrabajoSelector
                  DiaTrabajoSelector(
                    doctorSeleccionado: doctorId,
                    onChanged: (newValue) {
                      setState(() {
                        diaTrabajoSeleccionado = newValue;
                      });
                    },
                  ),

                  // Separador
                  const SizedBox(height: 20),

                  // Utilizando HorariosVisita
                  HorariosVisita(
                    doctorSeleccionado: doctorId,
                    onChanged: (newValue) {
                      setState(() {
                        horariosSeleccionados = newValue;
                      });
                    },
                  ),

                  // Separador
                  const SizedBox(height: 20),

                  // Selector de fecha
                  SelectorFecha(
                    onChanged: (DateTime selectedDate) {
                      setState(() {
                        _fechaSeleccionada = selectedDate;
                      });
                    },
                  ),

                  // Separador
                  const SizedBox(height: 20),

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

  Future<void> _guardarSolicitud() async {
    // Tu método _guardarSolicitud() aquí
  }
}
