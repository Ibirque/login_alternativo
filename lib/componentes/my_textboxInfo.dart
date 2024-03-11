import 'package:flutter/material.dart';

class MyTextBoxInfo extends StatelessWidget {
  final String texto;
  final String sectionName;
  final void Function()? onPressed;
  final void Function()? onPressedStats;
  const MyTextBoxInfo({
    super.key,
    required this.texto,
    required this.sectionName,
    required this.onPressed,
    required this.onPressedStats,
  });

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
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              //Boton de editar
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                texto,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: onPressedStats,
                icon: const Icon(
                  Icons.stacked_line_chart,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
