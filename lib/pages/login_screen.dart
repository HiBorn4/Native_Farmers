// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'home_screen.dart';
import 'register__screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = '';
  String smsCode = '';
  String verificationId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.message}'),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent.'),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code auto retrieval timed out.'),
          ),
        );
      },
    );
  }

  void signInWithPhoneNumber() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(credential);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              // Green container
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: constraints.maxHeight * 0.5,
                child: Container(
                  color: const Color(0xFF0D813D), // Green color code
                  child: Center(
                    child: Image.asset(
                      'assets/native_farmers_logo.png', // Replace with your image path
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                          .withOpacity(0.5), // Transparent grey color
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // White container
              Positioned(
                top: constraints.maxHeight * 0.4,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text('LOGIN',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text(
                          'People who eat organic foods have seen 30% decrement in digestion related problems',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF0F2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: (country) {
                                  // phoneNumber = country.dialCode!;
                                },
                                initialSelection: 'भारत',
                                favorite: const ['+91', 'भारत'],
                              ),
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Mobile Number',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  // onChanged: (value) {
                                  //   phoneNumber = value;
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF70F570), Color(0xFF277612)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .transparent, // Set the background color of the button to transparent
                              shadowColor:
                                  Colors.transparent, // Hide the button shadow
                            ),
                            onPressed: () {
                              verifyPhone();
                              // Check if the user is registered in the database
                              // bool isUserRegistered =
                              // true; // Add logic to check if user is registered in the database
                              // if (isUserRegistered) {
                              //   // Move user to home screen
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => HomeScreen(),
                              //     ),
                              //   );
                              // } else {
                              //   // Show snackbar to prompt user to register
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content:
                              //           const Text('Please register first.'),
                              //       action: SnackBarAction(
                              //         label: 'Register',
                              //         onPressed: () {
                              //           Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //               builder: (context) =>
                              //                   RegisterScreen(),
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Here to build your healthy life?'),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Color(0xFF0D813D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
