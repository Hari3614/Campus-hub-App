import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseService {
  static Future<void> initHive() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  static Future<void> createClass(String title, String division) async {
    final classBox = await Hive.openBox('classes');
    final newClass = {'title': title, 'division': division};
    await classBox.add(newClass);
  }
}
