import 'package:flutter/material.dart';

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
                                          // Add your delete visit logic here
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
