import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/editStudent_screen.dart';
import 'package:project_1/screens/mark_screen.dart';
import 'package:project_1/screens/studentadd.dart';
import 'package:project_1/database/db.model.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'student_details.dart'; // Import the StudentDetailsPage widget
import 'package:project_1/screens/attendancescreen.dart';
import 'package:project_1/screens/lesson_screen.dart';

class ClassInfo extends StatefulWidget {
  const ClassInfo({Key? key}) : super(key: key);

  @override
  State<ClassInfo> createState() => _ClassInfoState();
}

class _ClassInfoState extends State<ClassInfo> {
  int index = 0;
  ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    studentListNotifier.value = await getstudents();
  }

  Widget _buildStudentList(
      BuildContext context, List<StudentModel> studentList) {
    final searchQuery = _searchController.text.toLowerCase();
    final filteredList = searchQuery.isEmpty
        ? studentList
        : studentList
            .where((student) =>
                student.firstName.toLowerCase().contains(searchQuery) ||
                student.lastName.toLowerCase().contains(searchQuery) ||
                student.email.toLowerCase().contains(searchQuery))
            .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final student = filteredList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              // Navigate to StudentDetailsPage when a student is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailsPage(student: student),
                ),
              );
            },
            onLongPress: () {
              _showPopupMenu(context, student);
            },
            child: ListTile(
              leading: FutureBuilder<Uint8List?>(
                future: _getImageFromDatabase(student.imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a placeholder with a fixed size while loading
                    return Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300], // Placeholder color
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else {
                    final imageData = snapshot.data;
                    if (imageData != null) {
                      return CircleAvatar(
                        backgroundImage: MemoryImage(imageData),
                      );
                    } else {
                      return const Icon(Icons.person);
                    }
                  }
                },
              ),
              title: Text(
                '${student.firstName} ${student.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _getImageFromDatabase(String? imagePath) async {
    if (imagePath == null) return null;

    try {
      final file = File(imagePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error reading image file: $e');
      return null;
    }
  }

  Future<void> _deleteStudent(StudentModel student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text(
            'Are you sure you want to delete ${student.firstName} ${student.lastName}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceling
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirming
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await deleteStudent(student.id!);
      fetchStudents();
    }
  }

  void _showPopupMenu(BuildContext context, StudentModel student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 1, 255, 213), // Menu background color
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit), // Edit icon
                title: const Text('Edit'), // Edit text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentPage(student: student),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete), // Delete icon
                title: const Text('Delete'), // Delete text
                onTap: () {
                  Navigator.pop(context);
                  _deleteStudent(student);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.school, size: 30),
      const Icon(Icons.calendar_today, size: 30),
      const Icon(Icons.book, size: 30),
      const Icon(Icons.score, size: 30),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromRGBO(255, 0, 0, 0),
        color: const Color.fromARGB(255, 1, 255, 213),
        height: 60,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 300),
        index: index,
        items: items,
        onTap: (int tappedIndex) {
          setState(() {
            index = tappedIndex;
          });
        },
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    switch (index) {
      case 0:
        return _buildClassInfoPage();
      case 1:
        return const AttendanceAddingPage();
      case 2:
        return const LessonScreen();

      case 3:
        return const MarkScreen();

      default:
        return _buildClassInfoPage();
    }
  }

  Widget _buildClassInfoPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: Text(
          'Class Info',
          style: GoogleFonts.montserrat(
            // Use Google Fonts for Cinzel font
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 241, 241, 241),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 193, 193, 193)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          ValueListenableBuilder<List<StudentModel>>(
            valueListenable: studentListNotifier,
            builder: (context, studentList, _) {
              if (studentList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add students here ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Students: ${studentList.length}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(221, 60, 60, 60),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: ValueListenableBuilder<List<StudentModel>>(
              valueListenable: studentListNotifier,
              builder: (context, studentList, _) {
                if (studentList.isEmpty) {
                  return const Center(
                    child: Text(
                      'There are no students assigned \n for this class yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return _buildStudentList(context, studentList);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 65.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentAdd()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
