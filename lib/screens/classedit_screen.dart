import 'package:flutter/material.dart';
import 'package:project_1/database/db.dart';

// ignore: use_key_in_widget_constructors
class CreateClassScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 12, 206, 197),
          title: const Text('Create New Class'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _divisionController,
                decoration: const InputDecoration(
                  labelText: 'Division',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _createClass(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createClass(BuildContext context) async {
    final String title = _titleController.text.trim();
    final String division = _divisionController.text.trim();

    if (title.isNotEmpty && division.isNotEmpty) {
      await DatabaseService.createClass(title, division);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter both title and division.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
