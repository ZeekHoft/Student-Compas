import 'package:cs_compas/controllers/auth.dart';
import 'package:cs_compas/controllers/check_format.dart';
import 'package:cs_compas/pages/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = const FlutterSecureStorage();
  bool passwordVisible = false;

  Future<void> _saveEmail(String email) async {
    await storage.write(key: "email", value: email); //saves the inputed email
  }

  Future<void> _saveID(String idnumber) async {
    await storage.write(
        key: "idnumber", value: idnumber); //saves the inputed ID number
  }

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
                    CpuLogo(), //stateless widget below for CPU
                  ],
                ),
                const Text(
                  "Login",
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
                        hintText: "Enter Email"),
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

                //password
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    obscureText: passwordVisible,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: _idnumberCPUcontroller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("ID"),
                      hintText: "Enter ID Number",
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
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () async {
                        //login is pressed, and 2 types of validations is executed an empty check and a regex, we're also pushing the saved email and id number

                        final isValidEmail =
                            validateEmailAddress(_emailCPUcontroller.text);
                        final isvalidID =
                            validateIDNumber(_idnumberCPUcontroller.text);
                        try {
                          if (isValidEmail && isvalidID) {
                            try {
                              await AuthService.loginWithEmail(
                                      _emailCPUcontroller.text,
                                      _idnumberCPUcontroller.text)
                                  .then((value) {
                                if (value == "Login Successful") {
                                  _saveEmail(_emailCPUcontroller.text);
                                  _saveID(_idnumberCPUcontroller.text);
                                  styleSnackBar(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        email: _emailCPUcontroller.text,
                                        idnumber: _idnumberCPUcontroller.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  (ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Login up Error: $value"))));
                                }
                              });
                            } catch (e) {
                              if (kDebugMode) {
                                print("AuthService Error in login.dart: $e");
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
                                "Error within the validation in login.dart: $e");
                          }
                        }
                      },
                      child: const Text(
                        "Login Account",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Create Account"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text("Register",
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
      content: Text("You are now logged in to CS compass"),
      backgroundColor: Colors.amber,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CpuLogo extends StatelessWidget {
  const CpuLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(48), // Image radius
        child: Image.asset('assets/imageCPULogo.jpg', fit: BoxFit.cover),
      ),
    );
  }
}
