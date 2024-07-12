import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/foundation.dart';
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              "Hello Mr/Ms ${userName.toCapitalized()}, welcome to CS compass!",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("ID number: $idnumber",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
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
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        height: screenHeight * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Facebook page
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CCS facebook page",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse(
                        "https://www.facebook.com/groups/977686173457202"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageCCS.jpg'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              //Student Handbook
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CPU student handbook",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse(
                        "https://cpu.edu.ph/wp-content/uploads/2023/09/2023-gold-and-blue-student-handbook.pdf"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageHandbook.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //Canvas page

              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CPU online canvas",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse("https://cpu.instructure.com/login/canvas"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageCanvas.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //SOS page

              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "SOS student account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse("https://my.cpu.edu.ph/Membership/Login"), false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageSOS.jpg'),
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

  void _launchUrl(Uri uri, bool inAPP) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inAPP) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        } else {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("URI error in home.dart: ${e.toString()}");
      }
    }
  }

  BoxDecoration getContainerDecoration() {
    return BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: const BorderRadius.all(Radius.zero));
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
