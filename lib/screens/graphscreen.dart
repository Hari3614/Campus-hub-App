import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_1/database/db.model.dart'; // Import your database models

class GhraphPage extends StatelessWidget {
  final List<MarkModel> marks; // List of MarkModel objects from your database

  GhraphPage({required this.marks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              padding: EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSpots(),
                      isCurved: true,
                      barWidth: 4,
                    ),
                  ],
                  minY: 0, // Set minimum value for y-axis
                  maxY: 100, // Set maximum value for y-axis
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Mark Percentages', // You can change the text as needed
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              padding: EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: _generateSections(),
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Mark Distribution', // You can change the text as needed
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    // Convert your database model data into FlSpot data for the line chart
    List<FlSpot> spots = [];
    for (int i = 0; i < marks.length; i++) {
      spots.add(FlSpot(i.toDouble(), marks[i].obtainedMarks!.toDouble()));
    }
    return spots;
  }

  List<PieChartSectionData> _generateSections() {
    // Generate data for the pie chart based on mark distribution
    List<PieChartSectionData> sections = [];
    // Calculate count for each grade
    Map<String, int> gradeCount = {
      'A+': 0,
      'A': 0,
      'B': 0,
      'C': 0,
      'D': 0,
      'F': 0,
    };
    for (var mark in marks) {
      String grade = _calculateGrade(mark.obtainedMarks!, mark.totalMarks!);
      gradeCount[grade] = gradeCount[grade]! + 1;
    }
    // Generate sections for each grade
    gradeCount.forEach((grade, count) {
      sections.add(
        PieChartSectionData(
          color: _getGradeColor(grade),
          value: count.toDouble(),
          title: '$grade: $count',
          radius: 70,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    });
    return sections;
  }

  String _calculateGrade(int obtainedMarks, int totalMarks) {
    // Calculate grade based on obtained marks and total marks
    final percentage = (obtainedMarks / totalMarks) * 100;
    if (percentage >= 90) {
      return 'A+';
    } else if (percentage >= 80) {
      return 'A';
    } else if (percentage >= 70) {
      return 'B';
    } else if (percentage >= 60) {
      return 'C';
    } else if (percentage >= 50) {
      return 'D';
    } else {
      return 'F';
    }
  }

  Color _getGradeColor(String grade) {
    // Assign colors based on grade
    switch (grade) {
      case 'A+':
        return Colors.green;
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
