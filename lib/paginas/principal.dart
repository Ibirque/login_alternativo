import 'package:flutter/material.dart';
import 'package:login_alternativo/componentes/my_button.dart';
import 'package:login_alternativo/componentes/my_textfield.dart';
import 'package:login_alternativo/componentes/square_tile.dart';
import 'signup.dart';

class PaginaPrincipal extends StatelessWidget {
  PaginaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido a la página principal!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la lógica para ir a la página de SignUp
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaSignUp()),
                );
              },
              child: const Text('Ir a SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}
