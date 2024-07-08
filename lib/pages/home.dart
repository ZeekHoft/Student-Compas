import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  final String email, idnumber;

  const Home({
    super.key,
    required this.email,
    required this.idnumber,
  });

  @override
  State<Home> createState() => _HomeState();
}

int currentIndex = 0;

class _HomeState extends State<Home> {
  String email = "Easter egg AHAHHAHAH";
  String idnumber = "naka login kw nga wla ka register? nays ya";

  final storage = const FlutterSecureStorage();

  Future<void> _getEmail() async {
    email = await storage.read(key: "email") ?? "";
    setState(() {});
  }

  Future<void> _getID() async {
    idnumber = await storage.read(key: "idnumber") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _getEmail();
    _getID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disables back button
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: const Color.fromARGB(255, 1, 8, 104),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), label: "Announcements"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Log out"),
        ],
        currentIndex: currentIndex,
        onTap: (index) async {
          if (index == 3) {
            _alertDialog(context);
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
      backgroundColor: Colors.red,
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(email,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(idnumber,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const Calendar(),
            const Notifications(),
            const Login()
          ],
        ),
      ),
    );
  }

  Future<void> _alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log out of CS Compass?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/login");
                await AuthService.logout();
              },
              child: const Text("Confirm"),
            )
          ],
        );
      },
    );
  }
}
