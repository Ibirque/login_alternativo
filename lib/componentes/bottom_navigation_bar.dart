import 'package:flutter/material.dart';
import 'package:login_alternativo/paginas/perfil.dart';
import 'package:login_alternativo/paginas/principal.dart';
import 'package:login_alternativo/paginas/solicitarVisita.dart';
import 'package:login_alternativo/paginas/mapa.dart';

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
      icon: Icon(Icons.home, size: 24, color: Colors.red), // Tamaño del ícono ajustado
      label: 'Inicio',
      backgroundColor: Colors.black,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 24, color: Colors.green), // Tamaño del ícono ajustado
      label: 'Perfil',
      backgroundColor: Colors.black,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle, size: 24, color: Colors.purple), // Tamaño del ícono ajustado
      label: 'Cita',
      backgroundColor: Colors.black,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map, size: 24, color: Colors.red), // Tamaño del ícono ajustado
      label: 'Mapa',
      backgroundColor: Colors.black,
    ),
  ],
  currentIndex: currentIndex,
  selectedItemColor: Colors.amber[800],
  unselectedItemColor: Colors.white,
  onTap: onTap,
  backgroundColor: Colors.black,
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
        case 3:
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) =>
          MapsPage(), // Utiliza la clase MapsPage
    ),
  );
  break;
    }
  }
}
