import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText; // Texto del botón
  final Color backgroundColor; // Color de fondo del botón

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.backgroundColor = Colors.black, // Valor predeterminado para el color de fondo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Usar el color de fondo proporcionado
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(25),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
