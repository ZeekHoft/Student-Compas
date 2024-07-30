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
}

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
    'BSCS': 'assets/ccsLogo.jpg',
    'BSIT': 'assets/itsoPage.jpg',
    'BSLISSO': 'assets/lissoPage.jpg',
    'BSDMIA': 'assets/dmiaPage.jpg',
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
    String imagePath = courseImages[coursePrefix] ?? 'assets/smallCompass.jpg';

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.tertiaryColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: AppColors.tertiaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendar",
            backgroundColor: AppColors.tertiaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: "Announcements",
            backgroundColor: AppColors.tertiaryColor,
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
                colors: [
              Colors.white,
              Colors.white,
            ])),
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(
                            color: AppColors.tertiaryColor, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),

                    //profile logo
                    child: Row(
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(imagePath),
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
                            const Text("COURSE & YEAR:",
                                style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12.0)),
                            Text(course.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            const Text("ID NUMBER:",
                                style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12.0)),
                            Text(idnumber,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            const Text("PROVINCE:",
                                style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12.0)),
                            Text(province.toCapitalized(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  //Bottom team mention
                  const ActionButtons(),
                  const Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Created by CS Compass\n& Ternary Vanguards 🧭",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
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

//upper case the first letter cause theres no fking camel case function in dart
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
