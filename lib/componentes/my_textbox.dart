import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String texto;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.texto,
    required this.sectionName,
    required this.onPressed,
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
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,),
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
          Text(
            texto,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }
}
