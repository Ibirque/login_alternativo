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
  String? diaTrabajoSeleccionado;
  DateTime? _fechaSeleccionada;
  List<String>? horarioSeleccionado;

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
                        horarioSeleccionado = newValue;
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

  Future<bool> _checkDoctorAvailableOnSelectedDateTime(String doctorId,
      DateTime fechaSeleccionada, List<String> horariosSeleccionados) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
          await FirebaseFirestore.instance
              .collection('Doctor')
              .doc(doctorId)
              .get();

      if (!doctorSnapshot.exists) {
        return false;
      }

      QuerySnapshot<Map<String, dynamic>> reservationsSnapshot =
          await FirebaseFirestore.instance
              .collection('Doctor')
              .doc(doctorId)
              .collection('Reservas')
              .where('fecha', isEqualTo: fechaSeleccionada)
              .get();

      for (final reservation in reservationsSnapshot.docs) {
        final List<String> reservedTimes =
            List<String>.from(reservation.data()['horarios']);
        if (reservedTimes.contains(horariosSeleccionados)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error al verificar la disponibilidad del doctor: $e');
      return false;
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

      // Obtener el nombre del doctor
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
          await FirebaseFirestore.instance
              .collection('Doctor')
              .doc(doctorId)
              .get();

      String? nombreDoctor = doctorSnapshot.data()?['nombre'];

      // Almacenar el valor de doctorId en una variable local
      String doctorIdValue = doctorId!;

      if (doctorId != null && horarioSeleccionado != null) {
        // Verificar disponibilidad del doctor en el día y horario seleccionados
        bool disponibilidad = await _checkDoctorAvailableOnSelectedDateTime(
          doctorIdValue,
          _fechaSeleccionada!,
          horarioSeleccionado!,
        );

        if (disponibilidad) {
          // Obtener los días de trabajo del doctor desde Firestore
          DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
              await FirebaseFirestore.instance
                  .collection('Doctor')
                  .doc(doctorId)
                  .get();
          
          // Verificar si se encontró el documento del doctor
          if (doctorSnapshot.exists) {
            // Obtener los días de trabajo del doctor como una lista de días
            List<String> diasTrabajoDoctor = List<String>.from(doctorSnapshot.data()!['dias_trabajo_array']);
            
            // Convertir la lista de días de trabajo en un conjunto para facilitar la búsqueda
            Set<String> diasTrabajoSet = Set.from(diasTrabajoDoctor);
            
            // Verificar si el día seleccionado está en los días de trabajo del doctor
            if (!diasTrabajoSet.contains(_getWeekdayString(_fechaSeleccionada!.weekday))) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El doctor no trabaja este día. Por favor, selecciona otro día.'),
                ),
              );
              return; // Salir del método porque no se puede hacer la reserva en este día
            }
          }
          
          DocumentReference doctorRef =
              FirebaseFirestore.instance.collection('Doctor').doc(doctorId);
          CollectionReference reservasRef = doctorRef.collection('Reservas');
          await reservasRef.add({
            'fecha': _fechaSeleccionada,
            'horarios': horarioSeleccionado,
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

          // Guardar la cita en la colección del usuario
          DocumentReference usuarioRef = _firestore.collection('usuarios').doc(currentUser.email);
          CollectionReference citasRef = usuarioRef.collection('citas');
          await citasRef.add({
            'nombre_doctor': nombreDoctor,
            'doctorId': doctorId,
            'fecha': _fechaSeleccionada,
            'grupoSanguineo': 'Esperando resultados',
            'horarios': horarioSeleccionado,
            'notas': notas,
            'tipo': tipoVisitaSeleccionada,
            'userId': userId,
            'usermail': currentUser.email,
          });

          setState(() {
            _currentIndex = 0;
          });
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(0);
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visita guardada correctamente'),
          ),
        );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El horario seleccionado ya está reservado.'),
            ),
          );
        }
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona un doctor y una hora para la visita.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la solicitud de visita.'),
        ),
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
