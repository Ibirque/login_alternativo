import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_buttonsignup.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';
import 'login.dart'; // Importa la clase LoginScreen

class PaginaSignUp extends StatelessWidget {
  PaginaSignUp({Key? key}) : super(key: key);

  // Controladores de edición de texto
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Método para iniciar sesión
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Debemos incluir:

              //Logo Metagenetics
              const Icon(
                Icons.accessible,
                size: 100,
              ),

              //Bienvenida
              const SizedBox(height: 30),
              Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              //Nombre, apellido, seguridad social, correo password
              //Campo para username
              const SizedBox(height: 15), //Separacion
              MyTextField(
                controller: usernameController,
                hintText: 'Nombre',
                obscureText: false,
              ),

              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Apellido',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Seguridad Social',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'e-mail',
                obscureText: true,
              ),

              //Campo para password
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Confirmar Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 5),

              MyButton(
                onPressed: signUserIn,
              ),

              //O continuar con:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'O continua con',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/assets/iconogoogle.png'),
                ],
              ),                        
            ],
          ),
        ),
      ),
    );
  }
}
