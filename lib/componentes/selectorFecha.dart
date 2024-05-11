import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const DatePickerField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          filled: true,
          prefixIcon: const Icon(Icons.calendar_today),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString().split(" ")[0];
      });
    }
  }
}
