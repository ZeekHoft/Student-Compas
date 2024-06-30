// ignore_for_file: prefer_const_constructors

import 'package:cs_compas/controllers/auth.dart';
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
  String email = "";
  String idnumber = "";

  final storage = FlutterSecureStorage();

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
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/login");

                await AuthService.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Color.fromARGB(255, 1, 8, 104),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_add), label: "Announcements"),
        ],
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
      backgroundColor: Colors.red,
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(email, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child:
                          Text(idnumber, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            Calendar(),
            Notifications()
          ],
        ),
      ),
    );
  }
}
