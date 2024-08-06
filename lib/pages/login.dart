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

  Future<void> _saveEmail(String email) async {
    await storage.write(key: "email", value: email); //saves the inputed email
  }

  Future<void> _saveID(String idnumber) async {
    await storage.write(
        key: "idnumber", value: idnumber); //saves the inputed ID number
  }

  Future<void> _saveCourse(String course) async {
    await storage.write(key: "course", value: course);
  }

  Future<void> _saveProvince(String province) async {
    await storage.write(key: "province", value: province);
  }

  final TextEditingController _emailCPUcontroller = TextEditingController();
  final TextEditingController _idnumberCPUcontroller = TextEditingController();
  final TextEditingController _courseCPUcontroller = TextEditingController();
  final TextEditingController _provinceCPUcontroller = TextEditingController();

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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
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

                //idnumber
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: _idnumberCPUcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("ID"),
                        hintText: "Enter ID Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your ID Numbe";
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
                //Province
                const SizedBox(
                  height: 10.0,
                ),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(8)],
                        controller: _provinceCPUcontroller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Province"),
                            hintText: "Enter province"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Province";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    //course and year
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(9)],
                        controller: _courseCPUcontroller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Course & Year"),
                            hintText: "Enter e.g: BSCS-1"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Course";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),

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
                                  _saveCourse(
                                      _courseCPUcontroller.text.toUpperCase());
                                  _saveProvince(_provinceCPUcontroller.text);
                                  styleSnackBar(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                          email: _emailCPUcontroller.text,
                                          idnumber: _idnumberCPUcontroller.text,
                                          course: _courseCPUcontroller.text,
                                          province:
                                              _provinceCPUcontroller.text),
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
                        child: const Text("Register Here",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
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
    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(41), // Image radius
            child: Image.asset('assets/imageCPULogo.jpg', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(41), // Image radius
            child: Image.asset('assets/ccsLogo.jpg', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
