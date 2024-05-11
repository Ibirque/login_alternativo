import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaTrabajoSelector extends StatefulWidget {
  final String? doctorSeleccionado;
  final ValueChanged<String>? onChanged;

  const DiaTrabajoSelector({Key? key, this.doctorSeleccionado, this.onChanged}) : super(key: key);

  @override
  _DiaTrabajoSelectorState createState() => _DiaTrabajoSelectorState();
}

class _DiaTrabajoSelectorState extends State<DiaTrabajoSelector> {
  String? _diaSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Doctor').doc(widget.doctorSeleccionado).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || !data.containsKey('dias_trabajo')) {
            return const Text('Selecciona un doctor primero');
          }

          Map<String, dynamic> diasTrabajo = Map<String, dynamic>.from(data['dias_trabajo']);

          // Filtrar los días que tengan valor true
          List<String> diasHabilitados = diasTrabajo.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: 'Día de Trabajo',
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            value: _diaSeleccionado,
            onChanged: (newValue) {
              setState(() {
                _diaSeleccionado = newValue;
                widget.onChanged?.call(_diaSeleccionado!);
              });
            },
            items: diasHabilitados.map((dia) {
              return DropdownMenuItem<String>(
                value: dia,
                child: Text(dia),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
