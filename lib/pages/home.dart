import 'dart:async';

import 'package:cs_compas/controllers/actionbuttons.dart';
import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/controllers/color_control.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  final String email, idnumber, course, province;

  const Home(
      {super.key,
      required this.email,
      required this.idnumber,
      required this.course,
      required this.province});

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
  String course = "";
  String province = "";
  final storage = const FlutterSecureStorage();

  final courseImages = {
    'BSCS': 'assets/CS.png',
    'BSIT': 'assets/IT.png',
    'BSLISSO': 'assets/LISSO.png',
    'BSDMIA': 'assets/DMIA.png',
  };

  Future<void> _getEmail() async {
    email = await storage.read(key: "email") ?? "";
    setState(() {});
  }

  Future<void> _getID() async {
    idnumber = await storage.read(key: "idnumber") ?? "";
    setState(() {});
  }

  Future<void> _getCourse() async {
    course = await storage.read(key: "course") ?? "";
    setState(() {});
  }

  Future<void> _getProvince() async {
    province = await storage.read(key: "province") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _getEmail();
    _getID();
    _getCourse();
    _getProvince();
  }

  @override
  Widget build(BuildContext context) {
    String userName = getUserNameFromEmail(email);
    String coursePrefix = course.split('-')[0];

    String imagePath = courseImages[coursePrefix] ?? 'assets/OTHER.png';

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: AppColors.borderColor, width: 3))),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primary,
          selectedItemColor: AppColors.tertiary,
          unselectedItemColor: AppColors.textLight,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
              backgroundColor: AppColors.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Calendar",
              backgroundColor: AppColors.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement_rounded),
              label: "Announcements",
              backgroundColor: AppColors.primary,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout_rounded), label: "Log out"),
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
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.borderColor, width: 3))),

                  //profile logo
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("SURNAME:",
                                  style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 12.0)),
                              Text(userName.toCapitalized(),
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 20.0)),
                              const Text("ID NUMBER:",
                                  style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 12.0)),
                              Text("$idnumber ",
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(imagePath),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("PROVINCE:",
                                  style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 12.0)),
                              Text(province.toCapitalized(),
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 20.0)),
                              const Text("COURSE & YEAR:",
                                  style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 12.0)),
                              Text("$course ",
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Bottom team mention
                const Expanded(
                  child: ActionButtons(),
                ),
                const Text(
                  "A CS Compass & Ternary Vanguards creation 🧭",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Calendar(),
            const Notifications(),
            const Login(),
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
          title: const Text(
            "Log out of CS Compass?",
            style: TextStyle(color: AppColors.primary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/login");
                await AuthService.logout();
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          ],
        );
      },
    );
  }
}

//upper case the first letter cause theres no fking camel case function in dart
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
