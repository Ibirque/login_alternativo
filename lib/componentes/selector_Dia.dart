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

          if (data == null || !data.containsKey('horario_trabajo')) {
            return const Text(
            'Horario de trabajo: -Selecciona Dr/a.-', // Mostrar el horario de trabajo
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
          }

          String horarioTrabajo = data['horario_trabajo'];

          return Text(
            'Horario de trabajo: $horarioTrabajo', // Mostrar el horario de trabajo
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
