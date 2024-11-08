import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/firebase_options.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:cs_compas/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final navigatorkey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print("error in firebase initialization in main.dart: $e");
    }
  }
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("Api key");
  OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    final String? screen = data?["screen"];

    if (screen != null) {
      navigatorkey.currentState?.pushNamed(screen);
    }
  });

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorkey,
      theme: ThemeData(textTheme: GoogleFonts.nunitoSansTextTheme()),
      routes: {
        '/': (context) => const CheckUser(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(
              email: '',
              idnumber: '',
              course: '',
              province: '',
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
