import 'package:login_alternativo/paginas/perfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_up.dart';

class PaginaPrincipal extends StatefulWidget {
  PaginaPrincipal({Key? key}) : super(key: key);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? _selectedOption; // Estado para la opción seleccionada
  String? _username; // Nombre de usuario

  // Lista de opciones para el menú desplegable
  final List<String> _options = ['Perfil', 'Cerrar Sesión'];

  // Método para cerrar sesión
  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

  // Método para obtener el nombre de usuario del documento del usuario actual
  Future<void> getUsername() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user!.email)
              .get();

      setState(() {
        _username = userData.data()?['username'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  // Método para manejar la selección de una opción
  void _handleOptionSelected(String option) {
    if (option == 'Perfil') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
    } else if (option == 'Cerrar Sesión') {
      cerrarSesion(); // Cerrar sesión cuando se selecciona la opción correspondiente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo negro
        title: Text(
          _username ?? 'Usuario', // Si el nombre de usuario es nulo, muestra 'Usuario'
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white, // Texto blanco
          ),
        ),
        centerTitle: true,
        actions: [
          // DropdownButton personalizado con imagen como punto inicial
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/fav_icon.png'),
              ),
              value: _selectedOption,
              onChanged: (String? newValue) {
                if (newValue == 'Cerrar Sesión') {
                  cerrarSesion(); // Cerrar sesión cuando se selecciona la opción correspondiente
                }
              },
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¡Bienvenido ${user?.email}!",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
      ),
    );
  }
}
