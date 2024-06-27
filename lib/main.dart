import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/firebase_options.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(
      OSLogLevel.verbose); // Enable verbose logging for debugging (optional)
  OneSignal.initialize("71aac144-6b13-4bcd-ad79-f8e9fdc111b0");
  OneSignal.Notifications.requestPermission(true);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/notification',
      routes: {
        '/': (context) => const CheckUser(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(
              email: '',
              idnumber: '',
            ),
        '/notification': (context) => const Notifications(),
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
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
