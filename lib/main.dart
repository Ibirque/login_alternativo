import 'package:flutter/material.dart';
import 'package:login_alternativo/paginas/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPagina(),
    );
  }
}

/*Funcionalidades a integrar*/

/*
Mapa de farmacias
Alerta de avisos médicos
Boton SOS
Cita previa y gestor
*/