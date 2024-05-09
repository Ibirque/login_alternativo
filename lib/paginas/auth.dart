import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_alternativo/paginas/login.dart';
import 'package:login_alternativo/paginas/principal.dart';

class AuthPagina extends StatelessWidget {
  const AuthPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        //Si esta logeado el usuario lo mandamos a la pagina principal, sino devolvemos a login
        if(snapshot.hasData){
          return PaginaPrincipal();
        }else{
          return PaginaLogin();
        }
      }
    )
    
    );
  }
}
