// ignore_for_file: use_super_parameters, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_alternativo/componentes/my_textbox.dart';
import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _apellido;
  String? _cip;
  String? _grupoSanguineo;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    obtenerInformacionUsuario();
  }

  Future<void> obtenerInformacionUsuario() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestore.collection('usuarios').doc(currentUser.email).get();

      setState(() {
        _username = userData.data()?['username'];
        _apellido = userData.data()?['apellido'];
        _cip = userData.data()?['cip'];
        _grupoSanguineo = userData.data()?['grupoSanguineo'];
      });
    } catch (error) {
      print('Error al obtener la información del usuario: $error');
    }
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
            Center(
              child: Image.asset(
                'lib/assets/fav_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Mi información',
                style: TextStyle(color: Colors.black),
              ),
            ),
            MyTextBox(
              texto: _username ?? '',
              sectionName: 'username',
              onPressed: () => editfield('username'),
            ),
            MyTextBox(
              texto: _apellido ?? '',
              sectionName: 'apellido',
              onPressed: () => editfield('apellido'),
            ),
            MyTextBox(
              texto: _cip ?? '',
              sectionName: 'cip',
              onPressed: () => editfield('cip'),
            ),
            MyTextBox(
              texto: _grupoSanguineo ?? '',
              sectionName: 'Grupo Sanguineo',
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

          // Dependiendo del índice seleccionado, navegamos a la página correspondiente
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(index);
        },
      ),

      // bottomNavigationBar: MyBottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //     if (index == 0) {
      //       Navigator.pushReplacement(
      //         context,
      //         PageRouteBuilder(
      //           transitionDuration: const Duration(milliseconds: 500),
      //           transitionsBuilder:
      //               (context, animation, secondaryAnimation, child) {
      //             return FadeTransition(
      //               opacity: animation,
      //               child: child,
      //             );
      //           },
      //           pageBuilder: (context, animation, secondaryAnimation) =>
      //               PaginaPrincipal(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  Future<void> editfield(String field) async {}
}
