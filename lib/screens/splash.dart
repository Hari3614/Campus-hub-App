import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = false;

    await Future.delayed(const Duration(seconds: 2));

    // ignore: dead_code
    if (isLoggedIn) {
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 64,
              color: Colors.yellow,
            ),
            const SizedBox(height: 20),
            Text(
              'EduAdmin',
              style: GoogleFonts.rowdies(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Empowering Education',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            // Additional loading animation
            const SizedBox(height: 20),
            const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
