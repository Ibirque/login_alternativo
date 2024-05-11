import 'package:flutter/material.dart';

class SelectorFecha extends StatefulWidget {
  final void Function(DateTime selectedDate) onChanged;

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
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(15), // Padding ajustado
        margin: const EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Contenido centrado
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey[400],
            ),
            SizedBox(width: 10),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
