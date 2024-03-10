import 'package:login_alternativo/componentes/my_drawer.dart';
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
  String? _username; // Nombre de usuario

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  // Método para obtener el nombre de usuario del documento del usuario actual
  Future<void> getUsername() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('usuarios')
          .doc(user!.email)
          .get();

      setState(() {
        _username = userData.data()?['username'];
      });
    }
  }

  // Método para manejar la selección de una opción en el Drawer
  void _handleDrawerOptionSelected(String option) {
    if (option == 'Perfil') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
    }
  }

  // Método para cerrar sesión
  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo negro
        title: Image.asset(
          'lib/assets/logo_white.png',
          width: 200,
          height: 80, // Ajusta la altura según tus preferencias
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Colors.white), // Color del icono del Drawer
      ),
      drawer: MyDrawer(
        onPerfil: () => _handleDrawerOptionSelected('Perfil'),
        onCerrar: cerrarSesion,
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
