import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';
import 'package:login_alternativo/componentes/my_textbox.dart';
// import 'package:login_alternativo/componentes/my_drawer.dart';
import 'package:login_alternativo/componentes/my_textboxInfo.dart';
import 'package:login_alternativo/paginas/perfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_alternativo/paginas/charts.dart';
// ignore: unused_import
import 'sign_up.dart';

class PaginaPrincipal extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables, use_super_parameters
  PaginaPrincipal({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? _username; // Nombre de usuario
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  // Método para obtener el nombre de usuario del documento del usuario actual
  Future<void> getUsername() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('usuarios')
          .doc(user!.email)
          .get();

      setState(() {
        _username = userData.data()?['username'];
      });
    }
  }

  /*DRAWER OLD */
  
  // Método para manejar la selección de una opción en el Drawer
  // void _handleDrawerOptionSelected(String option) {
  //   if (option == 'Perfil') {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Perfil()),
  //     );
  //   }
  // }

  // Método para cerrar sesión
  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

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
        backgroundColor: Colors.black, // Fondo negro
        title: Image.asset(
          'lib/assets/logo_white.png',
          width: 200,
          height: 80, // Ajusta la altura según tus preferencias
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
            color: Colors.white), // Color del icono del Drawer
      ),
      
      
      // drawer: MyDrawer(
      //   onPerfil: () => _handleDrawerOptionSelected('Perfil'),
      //   onCerrar: cerrarSesion,
      // ),

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

            //Otros detalles
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

            // Nombre de usuario
            MyTextBox(
              texto: 'Consulta de cabecera',
              sectionName: 'Dra. Rovira',
              onPressed: () => editfield('username'),
            ),

            // Apellido
            MyTextBox(
              texto: 'Oftalmologia',
              sectionName: 'Dr. Sanchez',
              onPressed: () => editfield('apellido'),
            ),

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

            MyTextBox(
              texto: 'Consultar médico de cabecera',
              sectionName: 'Radiografias',
              onPressed: () => editfield('cip'),
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
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            // Navegar a la página de perfil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Perfil()),
            );
          } 
        },
      ),





    );
  }
  

  Future<void> editfield(String field) async {}
}
