import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Clase para representar los datos del gráfico
class ChartSampleData {
  final String elemento;
  final int maximos;
  final int valoresUsuario;
  final int minimos;

  ChartSampleData(
      {required this.elemento,
      required this.maximos,
      required this.valoresUsuario,
      required this.minimos});
}

// Datos de ejemplo para el gráfico
final List<ChartSampleData> chartData = <ChartSampleData>[
  ChartSampleData(
      elemento: 'Leucocitos',
      maximos: 12,
      valoresUsuario: 5,
      minimos: 4),
  ChartSampleData(
      elemento: 'Linfocitos',
      maximos: 45,
      valoresUsuario: 5,
      minimos: 19),
  ChartSampleData(
      elemento: 'Hemoglobina',
      maximos: 16,
      valoresUsuario: 5,
      minimos: 12),
  ChartSampleData(
      elemento: 'Glucosa',
      maximos: 11,
      valoresUsuario: 5,
      minimos: 7),
  ChartSampleData(
      elemento: 'Plaquetas / 10',
      maximos: 45,
      valoresUsuario: 5,
      minimos: 13),
  ChartSampleData(
      elemento: 'Colesterol',
      maximos: 22,
      valoresUsuario: 5,
      minimos: 0),
];

class ChartsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficas'),
      ),
      body: Center(
        child: SfCartesianChart(
          // Series de gráficos
          series: <BarSeries<ChartSampleData, String>>[
            BarSeries<ChartSampleData, String>(
              // Datos para la primera serie de barras
              dataSource: chartData,
              xValueMapper: (ChartSampleData sales, _) => sales.elemento,
              yValueMapper: (ChartSampleData sales, _) => sales.maximos,
              // Nombre de la primera serie
              name: 'Niveles máximos',
              color: Colors.red,
            ),
            BarSeries<ChartSampleData, String>(
              // Datos para la segunda serie de barras
              dataSource: chartData,
              xValueMapper: (ChartSampleData sales, _) => sales.elemento,
              yValueMapper: (ChartSampleData sales, _) => sales.valoresUsuario,
              // Nombre de la segunda serie
              name: 'Valores del paciente',
              color: Colors.blue,
            ),
            BarSeries<ChartSampleData, String>(
              // Datos para la tercera serie de barras
              dataSource: chartData,
              xValueMapper: (ChartSampleData sales, _) => sales.elemento,
              yValueMapper: (ChartSampleData sales, _) => sales.minimos,
              // Nombre de la tercera serie
              name: 'Niveles minimos',
              color: Colors.amber,
            ),
          ],
          // Estilo del gráfico
          primaryXAxis: CategoryAxis(),
          // Etiqueta del eje X
          title: ChartTitle(text: 'Análisis'),
          // Etiqueta del eje Y
          legend: Legend(isVisible: true),
        ),
      ),
    );
  }
}
