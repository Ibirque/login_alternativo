import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_buttonsignup.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';

class PaginaSignUp extends StatelessWidget {
  PaginaSignUp({super.key});

  // Controladores de edición de texto
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController apellidoControler = TextEditingController();
  final TextEditingController cipController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  

  // Método para iniciar sesión
  void registrarUsuario() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                      // Logo de tu aplicación
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.30),
                          BlendMode.overlay,
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/assets/fav_icon.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      //Bienvenida
                      const SizedBox(height: 30),
                      Text(
                        'Bienvenido',
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
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
                        controller: apellidoControler,
                        hintText: 'Apellido',
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),
                      MyTextField(
                        controller: cipController,
                        hintText: 'CIP Sanitario',
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),
                      MyTextField(
                        controller: emailController,
                        hintText: 'e-mail',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: confirmEmailController,
                        hintText: 'Confirmar e-mail',
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
                        controller: confirmPasswordController,
                        hintText: 'Confirmar Contraseña',
                        obscureText: true,
                      ),

                      const SizedBox(height: 5),

                      MyButton(
                        onPressed: registrarUsuario,
                      ),

                      //O continuar con:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'O continua con',
                                style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.blueGrey[900],
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
            ),
          ),
          // Botón de retroceso
          Positioned(
            left: 20,
            top: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Volver a la página anterior
              },
            ),
          ),
        ],
      ),
    );
  }
}
