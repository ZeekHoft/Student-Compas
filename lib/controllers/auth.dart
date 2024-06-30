import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      // Print the entire error object
      return e.message!; // Return the specific error message
    } catch (e) {
      // Print the entire error object
      return "Login failed. Please try again."; // Generic error message
    }
  }

  //check logout of user
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //check is the user is sing in or not

  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
