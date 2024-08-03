import 'package:cs_compas/controllers/actionbuttons.dart';
import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppColors {
  static const Color primaryColor = Colors.amber;
  static const Color secondaryColor = Colors.white;
  static const Color tertiaryColor = Colors.black;

  static const Color white = Color.fromRGBO(250, 248, 241, 1);
  static const Color black = Color.fromRGBO(28, 26, 21, 1);
  static const Color primary = Color.fromRGBO(255, 193, 7, 1);
  static const Color secondary = Color.fromRGBO(145, 116, 23, 1);
  static const Color accent = Color.fromRGBO(246, 202, 73, 1);
  static const Color container = Color.fromRGBO(253, 240, 200, 1);
}

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
  String getUserNameFromEmail(String email) {
    final nameRegex = RegExp(
        r'\.(.*?)(?=-)'); // Regex pattern, after the dot before the hyphen
    final match = nameRegex.firstMatch(email);
    return match?.group(1) ?? ""; // Extract the last name of the user
    // did not put in the controller because of more complex accessbility
  }

  String email = "";
  String idnumber = "";

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
    String userName = getUserNameFromEmail(email);

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.black, width: 2))),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.black,
          unselectedItemColor: AppColors.secondary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
              backgroundColor: AppColors.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: "Calendar",
              backgroundColor: AppColors.container,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement),
              label: "Announcements",
              backgroundColor: AppColors.container,
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
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.white),
        child: SafeArea(
          child: IndexedStack(
            index: currentIndex,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    decoration: const BoxDecoration(
                        color: AppColors.primary,
                        border: Border.symmetric(
                          horizontal:
                              BorderSide(color: AppColors.black, width: 3),
                        )),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 110,
                          width: 110,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(48),
                              child: Image.asset('assets/smallCompass.jpg'),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Text("SURNAME:",
                                style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12.0)),
                            Text(userName.toCapitalized(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            const Text("ID NUMBER:",
                                style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12.0)),
                            Text(idnumber,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: ActionButtons(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Created by CS Compass & Ternary Vanguards 🧭",
                      textAlign: TextAlign.center,
                    ),
                  ),
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
            style: TextStyle(color: AppColors.tertiaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/login");
                await AuthService.logout();
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            )
          ],
        );
      },
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
