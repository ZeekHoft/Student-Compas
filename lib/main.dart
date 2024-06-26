import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/firebase_options.dart';
import 'package:cs_compas/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:cs_compas/pages/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CheckUser(),
        '/signup': (context) => Signup(),
        '/login': (context) => Login(),
        '/home': (context) => const Home(
              email:
                  'hey this is one of the creators vince, if you managed to see this CONGRATULATIONS!!',
              idnumber: 'thats it thats the easter egg',
            ),
      },
    ),
  );
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
