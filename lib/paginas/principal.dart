import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';
import 'package:login_alternativo/componentes/my_textbox.dart';
import 'package:login_alternativo/componentes/my_textbox2.dart';
import 'package:login_alternativo/componentes/my_textboxinfo.dart'; // Importamos MyTextBox2
import 'package:login_alternativo/paginas/perfil.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:login_alternativo/paginas/charts.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? _username;
  int _currentIndex = 0;
  List<Widget> citasWidgets = []; 

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
    getUsername();
    getCitas();
  }

  // Función para cargar el nombre de usuario, usamos el id
  Future<void> getUsername() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user!.uid) 
              .get();

      setState(() {
        _username = userData.data()?['username'];
      });
    }
  }

  // Función para cargar las citas del usuario
  Future<void> getCitas() async {
    try {
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> citasSnapshot =
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user!.email)
                .collection('citas')
                .get() as QuerySnapshot<Map<String, dynamic>>;

        setState(() {
          // Limpiamos la lista de widgets antes de agregar los nuevos
          citasWidgets.clear();
          // Creamos un widget MyTextBox2 para cada cita encontrada
          citasSnapshot.docs.forEach((cita) {
            //Convertir fecha y hacer que sea una cadena legible
            DateTime fechaCita = (cita['fecha'] as Timestamp).toDate();
            String fechaFormateada = DateFormat.yMMMMd('es').format(fechaCita);

            //Buscamos el primer horario
            String primerHorario = '';
            List<dynamic> horarios = cita['horarios'];
            if (horarios != null && horarios.isNotEmpty) {
              primerHorario = horarios[0].toString();
            }

            citasWidgets.add(
              MyTextBox2(
                texto: cita['nombre_doctor'],
                sectionName: cita['tipo'],
                sectionName2: fechaFormateada,
                hora: primerHorario,
                notas: cita['notas'],
                documentId: cita.id,
                onPressed: () => editfield('username'),
                
              ),
            );
          });
        });
      } else {
        print('Usuario no autenticado.');
      }
    } catch (e) {
      print('Error retrieving citas: $e');
    }
  }

  //Nuestra pagina de estadisticas y charts
  void navigateToStatsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartsPage()),
    );
  }

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
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Mis visitas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            ...citasWidgets, // Como me gusta esto de reservar espacio xd
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Resultados disponibles',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            MyTextBoxInfo(
              texto: 'Resultados',
              sectionName: 'Laboratorio',
              onPressed: () => editfield('Sangre'),
              onPressedStats: navigateToStatsPage,
            ),
            MyTextBox(
              texto: 'Prueba de paternidad',
              sectionName: 'Laboratorio',
              onPressed: () => editfield('Sangre'),
            ),
          ],
        ),
      ),

      /*NavigationBar*/
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

  Future<void> editfield(String field) async {}
}