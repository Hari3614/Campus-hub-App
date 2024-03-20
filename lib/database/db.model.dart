import 'package:hive/hive.dart';
part 'db.model.g.dart';

@HiveType(typeId: 1)
class StudentModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String guardianName;

  @HiveField(4)
  String guardianPhoneNumber;

  @HiveField(5)
  String email;

  @HiveField(6)
  String address;

  @HiveField(7)
  String note;

  @HiveField(8)
  String? imagePath;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.guardianName,
    required this.guardianPhoneNumber,
    required this.email,
    required this.address,
    required this.note,
    this.imagePath,
    String? image,
  });

  get isDeleting => null;
}

@HiveType(typeId: 2)
class LessonModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  LessonModel({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
  });
}

@HiveType(typeId: 3)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<StudentModel> presentStudents;

  @HiveField(3)
  List<StudentModel> absentStudents;

  AttendanceModel({
    required this.id,
    required this.date,
    required this.presentStudents,
    required this.absentStudents,
  });
}

@HiveType(typeId: 4)
class MarkModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? subject;

  @HiveField(2)
  String? studentName;

  @HiveField(3)
  String? exam;

  @HiveField(4)
  String? examType;

  @HiveField(5)
  int? totalMarks;

  @HiveField(6)
  int? obtainedMarks;

  @HiveField(7)
  String? grade;

  MarkModel({
    required this.id,
    required this.subject,
    required this.studentName,
    required this.exam,
    required this.examType,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.grade,
  });
}
