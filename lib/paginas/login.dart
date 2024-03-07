import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_button.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';

class PaginaLogin extends StatelessWidget {
  PaginaLogin({super.key});

  //Controladores de edicion de texto
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            const SizedBox(height: 10),

            //Boton de registro
            MyButton(
              onTap: signUserIn,
            ),

            const SizedBox(height: 50),

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

            const SizedBox(height: 50),

             const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                SquareTile(imagePath: 'lib/assets/iconogoogle.png'),
              ],
            ),

            const SizedBox(height: 50),

            //Boton de inicio con google
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No estas registrado?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                
                const SizedBox(height: 4),
                const Text(
                  'Registrate',
                  style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold
                  )
                  ),
              ],

            )
          ]),
        ),
      ),
    );
  }
}
