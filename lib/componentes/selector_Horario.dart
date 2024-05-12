import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorariosVisita extends StatefulWidget {
  final String? doctorSeleccionado;
  final DateTime? fechaSeleccionada; // Nuevo parámetro
  final ValueChanged<List<String>>? onChanged;

  const HorariosVisita({
    Key? key,
    this.doctorSeleccionado,
    this.fechaSeleccionada,
    this.onChanged,
  }) : super(key: key);

  @override
  _HorariosVisitaState createState() => _HorariosVisitaState();
}

class _HorariosVisitaState extends State<HorariosVisita> {
  List<String>? _horariosSeleccionados;

  @override
  Widget build(BuildContext context) {
    // Verificar si tanto el doctor como la fecha están presentes
    if (widget.doctorSeleccionado == null || widget.fechaSeleccionada == null) {
      return const Center(
        child: Text(
          'Selecciona un doctor y una fecha para ver los horarios disponibles',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Doctor')
            .doc(widget.doctorSeleccionado)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || !data.containsKey('horarios_disponibles')) {
            return const Text(
                'Selecciona Dr/a. horario y fecha para poder ver las horas disponibles');
          }

          List<String> horariosDisponibles =
              List<String>.from(data['horarios_disponibles']);

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
              hintText: 'Horarios Disponibles',
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            value: _horariosSeleccionados?.isEmpty ?? true
                ? null
                : _horariosSeleccionados!.first,
            onChanged: (newValue) async {
              // Verificar disponibilidad antes de actualizar el estado
              final disponibilidad = await verificarDisponibilidad(
                widget.doctorSeleccionado!,
                newValue!,
                widget.fechaSeleccionada!,
              );
              if (disponibilidad) {
                setState(() {
                  _horariosSeleccionados = [newValue];
                  widget.onChanged?.call(_horariosSeleccionados!);
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Horario no disponible'),
                      content:
                          Text('El horario seleccionado ya está reservado.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            items: horariosDisponibles.map((horario) {
              // Verificar la disponibilidad del horario y establecer el color del texto
              return DropdownMenuItem<String>(
                value: horario,
                child: FutureBuilder<bool>(
                  future: verificarDisponibilidad(
                    widget.doctorSeleccionado!,
                    horario,
                    widget.fechaSeleccionada!,
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      // Determinar el color del texto según la disponibilidad
                      Color textColor =
                          snapshot.data! ? Colors.black : Colors.red;

                      return Text(
                        horario,
                        style: TextStyle(
                          color: textColor, // Cambia el color del texto
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error al verificar la disponibilidad');
                    } else {
                      return Text('Verificando disponibilidad...');
                    }
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

Future<bool> verificarDisponibilidad(
    String doctorId,
    String horarioSeleccionado,
    DateTime fechaSeleccionada,
) async {
    try {
        final reservasSnapshot = await FirebaseFirestore.instance
            .collection('Doctor')
            .doc(doctorId)
            .collection('Reservas')
            .where('fecha', isEqualTo: fechaSeleccionada)
            .get();
        
        for (final reserva in reservasSnapshot.docs) {
            final horariosReserva = reserva.data()['horarios'];
            if (horariosReserva.contains(horarioSeleccionado)) {
                return false; // El horario ya está reservado para la fecha seleccionada
            }
        }
        return true; // El horario está disponible para la fecha seleccionada
    } catch (e) {
        print('Error al verificar disponibilidad: $e');
        return false; // Error al verificar disponibilidad
    }
}


}
