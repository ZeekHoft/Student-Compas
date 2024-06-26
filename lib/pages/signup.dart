//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_compas/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/pages/check_format.dart';
import 'package:flutter/services.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailCPUcontroller = TextEditingController();
  final TextEditingController _idnumberCPUcontroller = TextEditingController();

  bool validEmail = false;
  bool validID = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.tealAccent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.pink),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    controller: _emailCPUcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                        hintText: "Enter CPU Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your CPU Email";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      final isValid = validateEmailAddress(value);
                      setState(() {
                        validEmail = isValid;
                      });
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: _idnumberCPUcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("ID"),
                        hintText: "Enter Student Number ID"),
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
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () async {
                        final isValidEmail =
                            validateEmailAddress(_emailCPUcontroller.text);
                        final isvalidID =
                            validateIDNumber(_idnumberCPUcontroller.text);
                        if (isValidEmail && isvalidID) {
                          await AuthService.createAccountWithEmail(
                                  _emailCPUcontroller.text,
                                  _idnumberCPUcontroller.text)
                              .then((value) {
                            if (value == "Account Created") {
                              styleSnackBar(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login', (Route<dynamic> route) => false);
                            } else {
                              print(ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Sign up Error: $value"))));
                            }
                          });
                        } else {
                          String errorMessage = "";
                          if (!isValidEmail) {
                            errorMessage += "Invalid Email Address\n";
                          }
                          if (!isvalidID) {
                            errorMessage += "Invalid ID Number";
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)));
                        }
                      },
                      child: const Text("Register Account")),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Already have an account"),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, "/login");
                        },
                        child: const Text("Login Here")),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void styleSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text("Account Created You Can Now Log In!!"),
      backgroundColor: Colors.amber,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
