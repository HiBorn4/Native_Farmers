import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
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
                      top: 40,
                      right: 10,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('REGISTER',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Please enter your mobile number to register'),
                  const SizedBox(height: 20),
                  const Row(
                    children: <Widget>[
                      CountryCodePicker(
                        onChanged: print,
                        initialSelection: 'US',
                        favorite: ['+1', 'US'],
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement phone authentication
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
