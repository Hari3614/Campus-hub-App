import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GhraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart Example'),
      ),
      body: Center(
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(1, 4),
                    FlSpot(2, 1),
                    FlSpot(3, 5),
                    FlSpot(4, 6),
                    FlSpot(5, 3),
                  ],
                  isCurved: true,
                  barWidth: 4,
                ),
              ],
              // colors: [Colors.blue], // Set colors here for the entire line chart
            ),
          ),
        ),
      ),
    );
  }
}
