import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';

class PaginaLogin extends StatelessWidget {
  PaginaLogin({super.key});

  //Controladores de edicion de texto
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const SizedBox(height: 50),
            // Debemos incluir:

            //Logo Metagenetics
            const Icon(
              Icons.lock,
              size: 100,
            ),

            //Bienvenida
            const SizedBox(height: 50),
            Text(
              'Bienvenido',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            
            //Campo para username
            const SizedBox(height: 25), //Separacion
            // Este campo esta creado en componentes->my_textfield.dart
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
            ),

            //Campo para password
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            //Password ovlidado
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '¿Password olvidado?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            //Boton de registro

            //Boton de inicio con google
          ]),
        ),
      ),
    );
  }
}
