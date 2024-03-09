import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            

          ],
        ),
      ),
    );
  }
}
