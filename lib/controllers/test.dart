//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_compas/controllers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:cs_compas/pages/check_format.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';

//import 'package:student_ccs/user_auth/firesbase_auth/firebase_auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCPUcontroller = TextEditingController();
  final TextEditingController _idnumberCPUcontroller = TextEditingController();

  bool validEmail = false;
  bool validID = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                // Prefer const constructor if used multiple times
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(10), // Prefer const constructor
              child: Form(
                key: _formKey, // Ensure _formKey is accessible
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: TextFormField(
                        controller: _emailCPUcontroller,
                        style: const TextStyle(
                            color: Colors.white), // Prefer const constructor
                        decoration: const InputDecoration(
                            hintText:
                                "CPU Emailszzdfsddsfssss"), // Consider shorter hint text
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null; // Add validation logic if needed
                          }
                        },
                        onChanged: (value) {
                          final isValid = validateEmailAddress(value);
                          setState(() {
                            validEmail = isValid;
                          });
                        },
                      ),
                    ),
                    Padding(
                      //Student id section
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: _idnumberCPUcontroller,
                          style: const TextStyle(color: Colors.white),
                          decoration:
                              const InputDecoration(hintText: "ID number"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Your ID number";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            final isValid = validateIDNumber(value);
                            setState(() {
                              validID = isValid;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10), // Consider adjusting padding
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String studentEmail = _emailCPUcontroller.text;
                              String studentID = _idnumberCPUcontroller.text;
                              if (validateEmailAddress(studentEmail) &&
                                  validateIDNumber(studentID)) {
                                try {
                                  String result =
                                      await AuthService.loginWithEmail(
                                          studentEmail, studentID);
                                  if (result == "Login Successful") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Login Successful")));
                                    _formKey.currentState!.reset();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(
                                          email: studentEmail,
                                          idnumber: studentID,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle failed login with specific error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(result)));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  // Handle specific Firebase Authentication errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message!)));
                                } catch (e) {
                                  // Handle other exceptions
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Login failed. Please try again.")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter a valid email and student ID."),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.send_outlined),
                          label: const Text("Submit"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
