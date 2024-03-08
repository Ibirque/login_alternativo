import 'sign_up.dart';

import 'package:flutter/material.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Página Principal',
          style: TextStyle(
            fontSize: 20, // Tamaño del texto ajustado según sea necesario
          ),
        ),
        centerTitle: true, // Centra el título en la AppBar
        actions: [
          IconButton(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.5), // Cambia el color y la opacidad según sea necesario
                BlendMode.overlay, // Cambia el modo de fusión según sea necesario
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/fav_icon.png'),
              ),
            ),
            onPressed: () {
              // Lógica para mostrar un menú emergente o realizar otra acción
            },
          ),
        ],
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
