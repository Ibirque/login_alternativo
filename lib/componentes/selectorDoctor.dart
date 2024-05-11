import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSelector extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const DoctorSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  _DoctorSelectorState createState() => _DoctorSelectorState();
}

class _DoctorSelectorState extends State<DoctorSelector> {
  String? _doctorSeleccionado;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctores').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error al cargar los datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<DropdownMenuItem<String>> items = [];
        snapshot.data!.docs.forEach((doc) {
          String nombreDoctor = doc['nombre'];
          items.add(DropdownMenuItem<String>(
            value: nombreDoctor,
            child: Text(nombreDoctor),
          ));
        });

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Doctor',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          value: _doctorSeleccionado,
          onChanged: (newValue) {
            setState(() {
              _doctorSeleccionado = newValue!;
              widget.onChanged?.call(newValue);
            });
          },
          items: items,
        );
      },
    );
  }
}
