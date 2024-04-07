import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/screens/attendance_edit.dart';
import 'package:table_calendar/table_calendar.dart';

ValueNotifier<List<AttendanceModel>> attendanceListNotifier = ValueNotifier([]);

Future<void> deleteAttendance(String key) async {
  final attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
  attendanceBox.delete(key);
}

Future<List<AttendanceModel>> getAttendances() async {
  final attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
  return attendanceBox.values.toList();
}

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceHistoryPageState createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late Box<AttendanceModel> _attendanceBox;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<AttendanceModel>> _events = {};

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    _attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
    _initializeEvents();
  }

  void _initializeEvents() {
    for (int i = 0; i < _attendanceBox.length; i++) {
      AttendanceModel attendance = _attendanceBox.getAt(i)!;
      DateTime date = attendance.date;
      _events.update(date, (value) => [attendance],
          ifAbsent: () => [attendance]);
    }
  }

  List<AttendanceModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: const Text('Attendance History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailsPage(selectedDay),
                ),
              );
            },
            eventLoader: _getEventsForDay,
          ),
          Expanded(
            child: ValueListenableBuilder<List<AttendanceModel>>(
              valueListenable: attendanceListNotifier,
              builder: (context, attendanceList, _) {
                return ListView.builder(
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) {
                    AttendanceModel attendance = attendanceList[index];
                    return ListTile(
                      title: Text('Date: ${attendance.date}'),
                      subtitle: Text(
                          'Present: ${attendance.presentStudents}, Absent: ${attendance.absentStudents}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteAttendance(attendance.id!);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAttendance(String key) async {
    try {
      await deleteAttendance(key);
      _events.removeWhere((date, attendanceList) {
        return attendanceList.any((attendance) => attendance.id == key);
      });
      List<AttendanceModel> updatedList =
          _events.values.expand((e) => e).toList();
      attendanceListNotifier.value = updatedList;
    } catch (e) {
      print('Error deleting attendance: $e');
    }
  }
}

class AttendanceDetailsPage extends StatelessWidget {
  final DateTime selectedDay;

  const AttendanceDetailsPage(this.selectedDay, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        centerTitle: true,
        title: const Text('Attendance Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAttendancePage(selectedDay),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteAttendanceForDate(selectedDay);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: _fetchAttendanceForDate(selectedDay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching attendance details'),
            );
          } else {
            List<AttendanceModel> attendanceList = snapshot.data!;
            if (attendanceList.isEmpty) {
              return const Center(
                child: Text(
                  'Attendance not added for this day',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 35, 35, 35),
                  ),
                ),
              );
            }

            List<String> presentStudents = attendanceList
                .expand((attendance) => attendance.presentStudents.split(', '))
                .toList();
            List<String> absentStudents = attendanceList
                .expand((attendance) => attendance.absentStudents.split(', '))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(
                    'Present Students',
                    presentStudents,
                    const Color.fromARGB(255, 46, 46, 46),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    'Absent Students',
                    absentStudents,
                    const Color.fromARGB(255, 46, 46, 46),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, List<String> students, Color color) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 300, // Set a minimum height
          minWidth: 200,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(
                  0, 3), // Offset to control the position of the shadow
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 0, // Set Card elevation to 0 to avoid duplicate shadows
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ), // Adjust the border radius as needed
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 174, 255, 82),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: students
                      .map(
                        (student) => Center(
                          child: Text(
                            student,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<AttendanceModel>> _fetchAttendanceForDate(DateTime date) async {
    try {
      Box<AttendanceModel> attendanceBox =
          Hive.box<AttendanceModel>('attendance');
      List<AttendanceModel> attendanceList = attendanceBox.values.where(
        (attendance) {
          return attendance.date.year == date.year &&
              attendance.date.month == date.month &&
              attendance.date.day == date.day;
        },
      ).toList();
      return attendanceList;
    } catch (e) {
      throw Exception('Error fetching attendance details: $e');
    }
  }

  Future<void> _deleteAttendanceForDate(DateTime date) async {
    try {
      Box<AttendanceModel> attendanceBox =
          Hive.box<AttendanceModel>('attendance');
      List keysToDelete = attendanceBox.keys.where(
        (key) {
          AttendanceModel attendance = attendanceBox.get(key)!;
          return attendance.date.year == date.year &&
              attendance.date.month == date.month &&
              attendance.date.day == date.day;
        },
      ).toList();
      for (String key in keysToDelete) {
        attendanceBox.delete(key);
      }
    } catch (e) {
      throw Exception('Error deleting attendance: $e');
    }
  }
}
