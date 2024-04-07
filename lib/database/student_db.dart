import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/database/db.model.dart';

//   <<...........Student Database...........>>

ValueNotifier<List<StudentModel>> dentListNotstuifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  final bookDB = await Hive.openBox<StudentModel>('students');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  bookDB.put(key, value);
  print(value);
}

Future<List<StudentModel>> getstudents() async {
  // ignore: non_constant_identifier_names
  final Studentbox = await Hive.openBox<StudentModel>('students');
  return Studentbox.values.toList();
}

Future<void> deleteStudent(String key) async {
  // ignore: non_constant_identifier_names
  final Studentbox = await Hive.openBox<StudentModel>('students');
  Studentbox.delete(key);
}

Future<void> updateStudent(StudentModel updatedValue) async {
  // ignore: non_constant_identifier_names
  final Studentbox = await Hive.openBox<StudentModel>('students');
  String key = updatedValue.id ?? '';
  Studentbox.put(key, updatedValue);
}

//  <<<.............Lesson Database.............>>>

ValueNotifier<List<LessonModel>> lessonListNotifier = ValueNotifier([]);

Future<void> addLesson(LessonModel value) async {
  final bookDB = await Hive.openBox<LessonModel>('lesson');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  bookDB.put(key, value);
  print(value);
}

Future<List<LessonModel>> getlesson() async {
  // ignore: non_constant_identifier_names
  final lessonbox = await Hive.openBox<LessonModel>('lesson');
  return lessonbox.values.toList();
}

Future<void> deleteLesson(String key) async {
  // ignore: non_constant_identifier_names
  final Studentbox = await Hive.openBox<LessonModel>('lesson');
  Studentbox.delete(key);
}

//   <<...........Attendance Database...........>>

ValueNotifier<List<AttendanceModel>> attendanceListNotifier = ValueNotifier([]);

Future<void> addAttendance(AttendanceModel value) async {
  final attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  await attendanceBox.put(key, value);
  print(value);
  await attendanceBox.close(); // Close the box after usage
}

Future<List<AttendanceModel>> getAttendances() async {
  final attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
  return attendanceBox.values.toList();
}

Future<void> deleteAttendance(String key) async {
  final attendanceBox = await Hive.openBox<AttendanceModel>('attendance');
  attendanceBox.delete(key);
  print('Record with key $key deleted from Hive database');
}

//   <<...........Mark Adding Database...........>>

ValueNotifier<List<MarkModel>> MarkListNotifier = ValueNotifier([]);

Future<void> addMark(MarkModel value) async {
  final markBox = await Hive.openBox<MarkModel>('mark');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  markBox.put(key, value);
  print(value);
}

Future<List<MarkModel>> getMark() async {
  final markBox = await Hive.openBox<MarkModel>('mark');
  return markBox.values.toList();
}

Future<void> deleteMark(String key) async {
  final markBox = await Hive.openBox<MarkModel>('mark');
  await markBox.delete(
      key); // Use await to ensure the operation completes before continuing
  print('Record with key $key deleted from Hive database');
}

ValueNotifier<List<UserModel>> UserListNotifier = ValueNotifier([]);

Future<void> addUser(UserModel value) async {
  final markBox = await Hive.openBox<UserModel>('user');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  markBox.put(key, value);
  print(value);
}

ValueNotifier<List<ClassModel>> ClassListNotifier = ValueNotifier([]);

Future<void> addClass(ClassModel value) async {
  final classBox = await Hive.openBox<ClassModel>('class');
  String key = DateTime.now().millisecondsSinceEpoch.toString();
  value.id = key;
  classBox.put(key, value);
  print(value);
}

Future<List<ClassModel>> getclass() async {
  final classBox = await Hive.openBox<ClassModel>('class');
  return classBox.values.toList();
}
