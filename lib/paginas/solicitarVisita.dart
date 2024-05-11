import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/my_button.dart';
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
  List<String> ciudadesDisponibles = ['Barcelona', 'Madrid', 'Zaragoza'];
  String? ciudadSeleccionada;
  String? doctorId;
  List<String> tiposVisita = ['Primera visita', 'Urgencias'];
  String? tipoVisitaSeleccionada;

  //Selectores
  String? doctorSeleccionado;
  List<String>? horariosSeleccionados;
  String? diaTrabajoSeleccionado;
  DateTime? _fechaSeleccionada;

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
                  DoctorSelector(
                    onChanged: (doctorData) {
                      setState(() {
                        doctorSeleccionado = doctorData['nombre'];
                        doctorId = doctorData['id'];
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DiaTrabajoSelector(
                    doctorSeleccionado: doctorId,
                    onChanged: (newValue) {
                      setState(() {
                        diaTrabajoSeleccionado = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SelectorFecha(
                    onChanged: (DateTime selectedDate, int weekday) {
                      setState(() {
                        _fechaSeleccionada = selectedDate;
                        diaTrabajoSeleccionado = _getWeekdayString(weekday);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  HorariosVisita(
                    doctorSeleccionado: doctorId,
                    fechaSeleccionada: _fechaSeleccionada,
                    onChanged: (newValue) {
                      setState(() {
                        horariosSeleccionados = newValue;
                      });
                    },
                  ),
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
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(index);
        },
      ),
    );
  }

  Future<bool> _checkDoctorAvailableOnSelectedDay(String doctorId, String? selectedDay) async {
    try {
      // Obtener la referencia del doctor
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
          await FirebaseFirestore.instance.collection('Doctor').doc(doctorId).get();
      
      // Verificar si el documento existe
      if (!doctorSnapshot.exists) {
        return false; // El doctor no existe
      }

      // Obtener el campo dias_trabajo del documento
      Map<String, dynamic> diasTrabajo = doctorSnapshot.data()?['dias_trabajo'] ?? {};

      // Verificar si el día seleccionado existe y su valor es true
      if (diasTrabajo.containsKey(selectedDay) && diasTrabajo[selectedDay] == true) {
        return true; // El doctor está disponible en el día seleccionado
      } else {
        return false; // El doctor no está disponible en el día seleccionado
      }
    } catch (e) {
      print('Error al verificar la disponibilidad del doctor: $e');
      return false; // Manejar el error
    }
  }

  Future<void> _guardarSolicitud() async {
    try {
      String ciudad = ciudadController.text;
      String notas = notasController.text;

      final User? user = currentUser;
      final String? userId = user?.uid;
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestore.collection('usuarios').doc(user?.email).get();

      String? _username = userData.data()?['username'];
      String? _apellido = userData.data()?['apellido'];
      String? _cip = userData.data()?['cip'];
      String? _grupoSanguineo = userData.data()?['grupoSanguineo'];

      // Almacenar el valor de doctorId en una variable local
    String doctorIdValue = doctorId!;


      if (doctorId != null &&
          horariosSeleccionados != null &&
          _fechaSeleccionada != null) {

        // Verificar disponibilidad del doctor en el día seleccionado
        bool isDoctorAvailable = await _checkDoctorAvailableOnSelectedDay(doctorIdValue, diaTrabajoSeleccionado);
   
        
        // Si el doctor no está disponible en el día seleccionado, mostrar un mensaje de error
        if (!isDoctorAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El doctor no está disponible en el día seleccionado')),
          );
          return;
        }

        DocumentReference doctorRef =
            FirebaseFirestore.instance.collection('Doctor').doc(doctorId);
        CollectionReference reservasRef = doctorRef.collection('Reservas');
        await reservasRef.add({
          'fecha': _fechaSeleccionada,
          'horarios': horariosSeleccionados,
          'notas': notas,
          'ciudad': ciudadSeleccionada,
          'tipo': tipoVisitaSeleccionada,
          'userId': userId,
          'usermail': currentUser.email,
          'username': _username,
          'apellido': _apellido,
          'cip': _cip,
          'grupoSanguineo': _grupoSanguineo,
          'doctorId': doctorId,
          'diaTrabajo': diaTrabajoSeleccionado,
        });
        setState(() {
            _currentIndex = 0;
          });
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(0);
        
      }     

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Solicitud de visita guardada exitosamente')),
            
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al guardar la solicitud de visita')),
      );
    }

  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }
}
