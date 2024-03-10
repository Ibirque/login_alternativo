import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_button.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';
import 'sign_up.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Perfil"
          ),
          backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),

          //Imagen de perfil
          //De momento usamos la imagen de metagenetics como imagen de perfil

          //Email de usuario

          //Otros detalles
        ],
      ),
      
    );
  }
}
