import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/screens/splash.dart';
import 'package:project_1/screens/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await _initHive();

  // Register Student model adapters
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(LessonModelAdapter());
  Hive.registerAdapter(AttendanceModelAdapter());
  Hive.registerAdapter(MarkModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ClassModelAdapter());

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        ThemeProvider themeProvider = ThemeProvider();
        themeProvider.loadSavedTheme(); // Load the saved theme
        return themeProvider;
      },
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themedata, // Use the theme provided by ThemeProvider
      home: const SplashScreen(),
    );
  }
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}
