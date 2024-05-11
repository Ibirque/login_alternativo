import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSelector extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onChanged;

  const DoctorSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  _DoctorSelectorState createState() => _DoctorSelectorState();
}

class _DoctorSelectorState extends State<DoctorSelector> {
  String? _doctorSeleccionado;
  Map<String, dynamic>? _doctores = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Doctor').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<DropdownMenuItem<String>> items = [];
          snapshot.data!.docs.forEach((doc) {
            String idDoctor = doc.id; // Obtener el ID del doctor
            String nombreDoctor = doc['nombre']; // Obtener el campo 'nombre' del doctor
            _doctores![nombreDoctor] = idDoctor; // Agregar el doctor al mapa
            items.add(DropdownMenuItem<String>(
              value: nombreDoctor,
              child: Text(
                nombreDoctor,
                style: TextStyle(color: Colors.black), // Estilo de texto
              ),
            ));
          });

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              // Ahora creamos el border distinto que cambia de color
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: 'Doctor',
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            value: _doctorSeleccionado,
            onChanged: (newValue) {
              setState(() {
                _doctorSeleccionado = newValue!;
                widget.onChanged?.call({'nombre': newValue, 'id': _doctores![newValue]}); // Devolver nombre e ID del doctor seleccionado
              });
            },
            items: items,
          );
        },
      ),
    );
  }
}
