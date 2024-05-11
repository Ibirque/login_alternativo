import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectorFecha extends StatefulWidget {
  final void Function(DateTime selectedDate, int weekday) onChanged;

  const SelectorFecha({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SelectorFechaState createState() => _SelectorFechaState();
}

class _SelectorFechaState extends State<SelectorFecha> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(_selectedDate, _selectedDate.weekday);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(15), // Padding ajustado
        margin: const EdgeInsets.symmetric(horizontal: 25), // Margen horizontal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Contenido centrado
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey[400],
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  _getWeekdayString(_selectedDate.weekday),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }


  Future<bool> _checkDoctorAvailableOnSelectedDay(String doctorId, String? selectedDay) async {
  try {
    // Obtener la referencia del doctor
    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
        await FirebaseFirestore.instance.collection('Doctor').doc(doctorId).get();
    
    // Verificar si el documento existe
    if (!doctorSnapshot.exists) {
      return false; // El doctor no existe
    }

    // Obtener el campo dias_trabajo del documento
    Map<String, dynamic> diasTrabajo = doctorSnapshot.data()?['dias_trabajo'] ?? {};

    // Verificar si el día seleccionado existe y su valor es true
    if (diasTrabajo.containsKey(selectedDay) && diasTrabajo[selectedDay] == true) {
      return true; // El doctor está disponible en el día seleccionado
    } else {
      return false; // El doctor no está disponible en el día seleccionado
    }
  } catch (e) {
    print('Error al verificar la disponibilidad del doctor: $e');
    return false; // Manejar el error
  }
}

}
