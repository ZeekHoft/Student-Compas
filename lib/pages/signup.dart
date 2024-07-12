import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/pages/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cs_compas/controllers/check_format.dart';
import 'package:flutter/services.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool passwordVisible = false;
  final TextEditingController _emailCPUcontroller = TextEditingController();
  final TextEditingController _idnumberCPUcontroller = TextEditingController();

  bool validEmail = false;
  bool validID = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Optional
                  children: [
                    CpuLogo(),
                  ],
                ),
                const Text(
                  "Sign up",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
                  height: 5.0,
                ),

                //password
                TextFormField(
                    obscureText: passwordVisible,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: _idnumberCPUcontroller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("ID"),
                      hintText: "Enter Student Number ID",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility)),
                    ),
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
                  height: 5.0,
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
                        try {
                          if (isValidEmail && isvalidID) {
                            try {
                              await AuthService.createAccountWithEmail(
                                      _emailCPUcontroller.text,
                                      _idnumberCPUcontroller.text)
                                  .then((value) {
                                if (value == "Account Created") {
                                  styleSnackBar(context);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login',
                                      (Route<dynamic> route) => false);
                                } else {
                                  (ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Sign up Error: $value"))));
                                }
                              });
                            } catch (e) {
                              if (kDebugMode) {
                                print("AuthService Erron in singup.dart: $e");
                              }
                            }
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
                        } catch (e) {
                          if (kDebugMode) {
                            print(
                                "Error withint the validation in signup.dart: $e");
                          }
                        }
                      },
                      child: const Text("Register Account",
                          style: TextStyle(color: Colors.black))),
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
                        child: const Text("Login Here",
                            style: TextStyle(color: Colors.black))),
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
