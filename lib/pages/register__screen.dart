import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'home_screen.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Top half of the screen for the logo and skip button
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 100.w, // 100% of the screen width
                  height: 50.h, // 50% of the screen height
                  color: const Color(0xFF0D813D), // Green color code
                  child: Center(
                    child: Image.asset(
                      'assets/native_farmers_logo.png', // Replace with your image path
                      width: 50.w, // 50% of the screen width
                      height: 25.h, // 25% of the screen height
                    ),
                  ),
                ),
                Positioned(
                  top: 5.h, // 5% of the screen height from the top
                  right: 5.w, // 5% of the screen width from the right
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
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
          // Bottom half of the screen for the registration form
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(5.w), // Padding as 5% of the screen width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'REGISTER',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h), // 2% of the screen height
                  const Text('Please enter your mobile number to register'),
                  SizedBox(height: 3.h), // 3% of the screen height
                  Row(
                    children: <Widget>[
                      const CountryCodePicker(
                        onChanged: print,
                        initialSelection: 'US',
                        favorite: ['+1', 'US'],
                      ),
                      SizedBox(width: 2.w), // 2% of the screen width
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h), // 4% of the screen height
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement phone authentication
                      },
                      child: const Text('Register'),
                    ),
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
