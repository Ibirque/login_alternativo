import 'package:flutter/material.dart';
import 'package:login_alternativo/paginas/perfil.dart';
import 'package:login_alternativo/paginas/principal.dart';
import 'package:login_alternativo/paginas/solicitarVisita.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.red), // Cambia el color del ícono aquí
          label: 'Inicio',
          backgroundColor: Colors.black, // Cambia el color de fondo aquí
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.green), // Cambia el color del ícono aquí
          label: 'Perfil',
          backgroundColor: Colors.black, // Cambia el color de fondo aquí
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.purple), // Cambia el color del ícono aquí
          label: 'Cita',
          backgroundColor: Colors.black, // Cambia el color de fondo aquí
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.white,
      onTap: onTap,
      backgroundColor: Colors.black, // Establece el color de fondo de la barra de navegación como negro
    );
  }
}

class NavigationHandler {
  final BuildContext context;

  NavigationHandler(this.context);

  void handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => PaginaPrincipal(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => Perfil(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => SolicitarVisita(),
          ),
        );
        break;
    }
  }
}
