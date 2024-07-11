import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: "Timeline",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: "Announcements",
            backgroundColor: Colors.black,
          ),
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
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.white])),
        child: SafeArea(
          child: IndexedStack(
            index: currentIndex,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(email,
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 20.0)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(idnumber,
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 20.0)),
                      ),
                    ],
                  ),
                  const ActionButtons()
                ],
              ),
              const Calendar(),
              const Notifications(),
              const Login(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Log out of CS Compass?",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.amber),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/login");
                await AuthService.logout();
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.amber),
              ),
            )
          ],
        );
      },
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: SizedBox(
        height: screenHeight * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print("object");
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Image.asset('assets/image3.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
