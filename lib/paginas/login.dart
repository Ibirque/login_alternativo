import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_button.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';
import 'sign_up.dart';

class PaginaLogin extends StatelessWidget {
  PaginaLogin({super.key});

  //Controladores de edicion de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn(BuildContext context) async {
    //circulo de carga
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    /*AUTENTICACION*/
    // CODIGO VESTIGIAL, USAR SI NO HAY AUTH
    //Navegar a la pagina principal
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const PaginaPrincipal()), // Reemplaza PaginaPrincipal() con el nombre de tu clase principal
    // );

    //Aqui hacemos la autentificación de usuario
    try {      
      // print('Antes de signInWithEmailAndPassword');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        //Mail erroneo
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        emailErroneo(context);    
      }       
      //Debido a los nuevos updates de firebase/google, no debemos darle 
      //datos a la gente de que credencial es la que esta fallando
      // else if (e.code == 'wrong-password') {
      //   //Password erroneo
      //   // ignore: use_build_context_synchronously
      //   passwordErroneo(context);
      // }
    }
  }

  void emailErroneo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Usuario no reconocido'),
        );
      },
    );
  }

  //ignoraremos passwordErroneo
  // void passwordErroneo(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Contraseña incorrecta'),
  //       );
  //     },
  //   );
  // }

  //Transicion de página
  void navegarRegistro(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 500), // Duración de la animación
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: PaginaSignUp(),
        );
      },
    ));
  }

  //Transiciones disponibles
  /*
  FadeTransition
  SlideTransition
  ScaleTransition
  RotationTransition
  SizeTransition
  SizeTransition
  DecoratedBoxTransition
  AlignTransition
  PositionedTransition
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          //SingleChildScrollView - Para arreglar el overflow pixel
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Debemos incluir:

              //Logo Metagenetics
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(
                      0.30), // Cambia este color y opacidad según lo necesites
                  BlendMode
                      .overlay, // Cambia el modo de fusión según lo necesites
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
              const SizedBox(height: 50),
              Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),

              //Campo para username
              const SizedBox(height: 25), //Separacion
              // Este campo esta creado en componentes->my_textfield.dart
              MyTextField(
                controller: emailController,
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
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //Boton de registro
              MyButton(
                onPressed: () {
                  signUserIn(context);
                },
              ),

              const SizedBox(height: 30),

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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

              const SizedBox(height: 50),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => navegarRegistro(
                        context), // Usar la función para navegar con animación
                    child: Text(
                      ' Registrate',
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
