import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/screens/login_screen.dart';
import 'package:project_1/screens/classedit_screen.dart';
import 'package:project_1/screens/class_info.dart';
import 'package:project_1/screens/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Box _classBox;
  late Box _userBox;
  bool _isBoxInitialized = false;
  bool _isUserBoxInitialized = false;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    final appDocumentDir =
        //    await path_provider.getApplicationDocumentsDirectory();
        // await Hive.initFlutter(appDocumentDir.path);
        _classBox = await Hive.openBox('classes');
    _userBox = await Hive.openBox('user');
    setState(() {
      _isBoxInitialized = true;
      _isUserBoxInitialized = true;
    });

    // Check if image path is already saved
    final imagePath = _userBox.get('imagePath', defaultValue: '');
    if (imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBoxInitialized || !_isUserBoxInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 12, 206, 197),
          title: Text(
            "Classes",
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 12, 206, 197),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : null,
                            child: _imageFile == null
                                ? const Icon(Icons.person,
                                    size: 120,
                                    color: Color.fromARGB(255, 12, 206, 197))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _isUserBoxInitialized
                        ? ValueListenableBuilder(
                            valueListenable: _userBox.listenable(),
                            builder: (context, Box box, _) {
                              final username = _userBox.get('username',
                                  defaultValue: 'Username');
                              return GestureDetector(
                                onTap: _editUsername,
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.home,
                      size: 25,
                      color: Color.fromARGB(255, 56, 56, 56),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 69, 69, 69),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 25,
                      color: Color.fromARGB(255, 56, 56, 56),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 69, 69, 69),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 69, 69, 69),
                  ),
                ),
                leading: const Icon(
                  Icons.exit_to_app,
                  size: 25,
                  color: Color.fromARGB(255, 56, 56, 56),
                ),
                onTap: () async {
                  _logout(context);
                },
              ),
              const Divider(),
              const SizedBox(
                height: 250,
              ),
              ListTile(
                title: const Center(
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Expanded(
              child: _buildClassCards(),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateClassScreen()),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCards() {
    return ValueListenableBuilder(
      valueListenable: _classBox.listenable(),
      builder: (context, Box box, _) {
        if (_classBox.isEmpty) {
          return const Center(
            child: Text(
              'No classes added yet \n Please add classes. ',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 161, 157, 157),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _classBox.length,
          itemBuilder: (context, index) {
            final classData = _classBox.getAt(index) as Map?;
            final title = classData?['title'] ?? 'No Title';
            final division = classData?['division'] ?? 'No Division';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClassInfo(),
                  ),
                );
              },
              child: Card(
                color: const Color.fromARGB(255, 118, 255, 223),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            division,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          _showClassOptions(context, index);
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 14,
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showClassOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditScreen(context, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  _showDeleteConfirmation(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this class?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteClass(index);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteClass(int index) {
    _classBox.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Class deleted'),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, int index) {}

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Reset login status
                final Box _boxLogin = Hive.box('login');
                _boxLogin.put('loginStatus', false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _userBox.put('imagePath', pickedFile.path); // Save image path in Hive
    }
  }

  void _editUsername() {
    TextEditingController usernameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (usernameController.text.isNotEmpty) {
                  _userBox.put('username', usernameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
