import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/controllers/notification_service.dart';
import 'package:cs_compas/firebase_options.dart';
import 'package:cs_compas/pages/message.dart';
import 'package:cs_compas/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:cs_compas/pages/login.dart';

final navigatorkey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future _firebaseBackroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Notification from the background");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initialize firebase messaging
  await PushNotifications.init();

  // initialize local notifications
  await PushNotifications.localNotificationInit();

  // listen to background notification
  FirebaseMessaging.onBackgroundMessage(_firebaseBackroundMessage);

  // navigate to mssg.dart if notification is tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Notification from the background");
      navigatorkey.currentState!.pushNamed('/message', arguments: message);
    }
  });

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorkey,
      routes: {
        '/': (context) => const CheckUser(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(
              email: '',
              idnumber: '',
            ),
        '/message': (context) => const MessagePopUP(),
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
