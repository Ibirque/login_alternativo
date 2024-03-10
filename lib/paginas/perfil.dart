import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_alternativo/componentes/my_textbox.dart';

class Perfil extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Perfil({Key? key});

  @override
  State<Perfil> createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _apellido;
  String? _cip;
  String? _grupoSanguineo;

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
      // ignore: avoid_print
      print('Error al obtener la información del usuario: $error');
    }
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
        iconTheme:
            const IconThemeData(color: Colors.white), // Color del icono del Drawer
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/fondo2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 50),

            //Imagen de perfil
            //De momento usamos la imagen de metagenetics como imagen de perfil
            Center(
              child: Image.asset(
                'lib/assets/fav_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            //Email de usuario
            const SizedBox(height: 10),
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),

            //Otros detalles
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Mi información',
                style: TextStyle(color: Colors.black),
              ),
            ),

            // Nombre de usuario
            MyTextBox(
              texto: _username ?? '',
              sectionName: 'username',
              onPressed: () => editfield('username'),
            ),

            // Apellido
            MyTextBox(
              texto: _apellido ?? '',
              sectionName: 'apellido',
              onPressed: () => editfield('apellido'),
            ),

            // Cip
            MyTextBox(
              texto: _cip ?? '',
              sectionName: 'cip',
              onPressed: () => editfield('cip'),
            ),

            // Grupo Sanguineo
            MyTextBox(
              texto: _grupoSanguineo ?? '',
              sectionName: 'Grupo Sanguineo',
              onPressed: () => editfield('Sangre'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editfield(String field) async {}
}
