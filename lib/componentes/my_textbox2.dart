import 'package:flutter/material.dart';

class MyTextBox2 extends StatelessWidget {
  final String texto;
  final String sectionName;
  final String sectionName2; // Nuevo parámetro para mostrar la fecha de la cita
  final String hora; // Nuevo parámetro para mostrar la hora de la cita
  final void Function()? onPressed;
  
  const MyTextBox2({
    Key? key,
    required this.texto,
    required this.sectionName,
    required this.sectionName2,
    required this.hora,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 15,
        right: 15, // Added right padding for the icon
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                texto,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Botón de editar
              IconButton(
                onPressed: onPressed,
                icon:  Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Added space between text and icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo de visita: $sectionName',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$sectionName2 a las $hora', 
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
