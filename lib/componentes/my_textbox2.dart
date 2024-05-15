import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_alternativo/paginas/principal.dart';
import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';

class MyTextBox2 extends StatelessWidget {
  final String texto;
  final String sectionName;
  final String sectionName2;
  final String hora;
  final String notas;
  final String documentId;
  final void Function()? onPressed;

  const MyTextBox2({
    Key? key,
    required this.texto,
    required this.sectionName,
    required this.sectionName2,
    required this.hora,
    required this.notas,
    required this.documentId,
    required this.onPressed,
  }) : super(key: key);

  //Funcion responsable de borrar el documento
  Future<void> funcionDelete() async {
    try {
      // Obtenemos una instancia de Firebase Auth
      FirebaseAuth auth = FirebaseAuth.instance;

      // Obtenemos el usuario actual
      User? user = auth.currentUser;

      // Verificamos si el usuario está autenticado
      if (user != null) {
        // Obtenemos una instancia de Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Eliminamos el documento usando su ID
        await firestore
            .collection('usuarios')
            .doc(user.email)
            .collection('citas')
            .doc(documentId)
            .delete();

        // Documento eliminado exitosamente
        print('Documento eliminado correctamente');
      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      // Manejo de errores
      print('Error al eliminar el documento: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texto,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sectionName2,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(texto),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tipo de cita: $sectionName'),
                            Text('Fecha de la cita: $sectionName2'),
                            Text('Hora: $hora'),
                            Text('Notas: $notas'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('¿Está seguro?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          funcionDelete();
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                        },
                                        child: Text('Sí'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Eliminar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
