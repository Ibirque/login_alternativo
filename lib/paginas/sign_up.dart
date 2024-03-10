import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_buttonsignup.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_alternativo/paginas/login.dart';
import 'package:login_alternativo/main.dart';

class PaginaSignUp extends StatelessWidget {
  PaginaSignUp({super.key});

  // Controladores de edición de texto
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController apellidoControler = TextEditingController();
  final TextEditingController cipController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Método para iniciar sesión
  Future<bool> registrarUsuario(
    String username,
    String apellido,
    String cip,
    String email,
    String confirmPassword,
  ) async {
    try {
      // Obtener los valores de los controladores de texto
      String username = usernameController.text;
      String apellido = apellidoControler.text;
      String cip = cipController.text;
      String email = emailController.text;
      String password = passwordController.text;

      // Estructurar los datos
      Map<String, dynamic> userData = {
        'username': username,
        'apellido': apellido,
        'cip': cip,
        'email': email,
        // Agregar otros campos aquí si es necesario
      };

      // Crear una cuenta de usuario en Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar los datos en la base de datos
      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(email)
          .set(userData);

      // Registro exitoso, puedes navegar a otra página o mostrar un mensaje de éxito
      return true;
    } catch (e) {
      // Manejar cualquier error
      print('Error al registrar el usuario: $e');
      return false;
    }
  }

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
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),
                      MyTextField(
                        controller: cipController,
                        hintText: 'CIP Sanitario',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),
                      MyTextField(
                        controller: emailController,
                        hintText: 'e-mail',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: confirmEmailController,
                        hintText: 'Confirmar e-mail',
                        obscureText: false,
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
                        onPressed: () async {
                          bool success = await registrarUsuario(
                            usernameController.text,
                            apellidoControler.text,
                            cipController.text,
                            emailController.text,
                            confirmPasswordController.text,
                          );
                          if (success) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()),
                            );
                          } else {
                            // fallo de registro
                          }
                        },
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
