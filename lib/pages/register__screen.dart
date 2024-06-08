// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:native_farmers/pages/login_screen.dart';
import 'package:native_farmers/widgets/card.dart';
import 'package:sizer/sizer.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _phoneNumber = '';
  bool _isPhoneNumberValid = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _phoneNumber = _phoneController.text;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final confirmationResult = await _auth.signInWithPhoneNumber(
          _phoneNumber,
        );

        // Assuming the OTP handling is done separately
        // Here, we need to verify the user
        UserCredential userCredential = await confirmationResult
            .confirm('123456'); // Use the actual OTP received

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'phone': _phoneNumber,
          'pincode': _pincodeController.text.trim(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _detectPincode() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    setState(() {
      _pincodeController.text = placemarks.first.postalCode ?? '';
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _validatePhoneNumber() {
    String phone = _phoneController.text.trim();
    if (phone.length == 10) {
      setState(() {
        _isPhoneNumberValid = true;
        _currentStep = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid mobile number')),
      );
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPhoneInput();
      case 1:
        return _buildNameInput();
      case 2:
        return _buildPincodeInput();
      default:
        return _buildPhoneInput();
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    Widget? icon,
    VoidCallback? onButtonPressed,
    required VoidCallback onNextPressed,
    required bool isLastStep,
  }) {
    return Column(
      children: <Widget>[
        Container(
          width: 90.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF0F2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    radius: 5.w,
                    child: icon,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: labelText,
                  ),
                ),
              ),
              if (onButtonPressed != null)
                IconButton(
                  icon: const Icon(Icons.gps_fixed, color: Colors.grey),
                  onPressed: onButtonPressed,
                ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 35.w,
          height: 6.h,
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
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: onNextPressed,
            child: Text(
              isLastStep ? 'Register' : 'Next',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildProgressIndicator(),
      ],
    );
  }

  Widget _buildNameInput() {
    return _buildInputField(
      controller: _nameController,
      labelText: 'Name',
      icon: Icon(Icons.person, color: Colors.grey, size: 6.w),
      onButtonPressed: null,
      onNextPressed: () {
        setState(() {
          _currentStep = 2;
        });
      },
      isLastStep: false,
    );
  }

  Widget _buildPincodeInput() {
    return _buildInputField(
      controller: _pincodeController,
      labelText: 'Pincode',
      icon: Icon(Icons.location_on, color: Colors.grey, size: 6.w),
      onButtonPressed: _detectPincode,
      onNextPressed: _register,
      isLastStep: true,
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      children: <Widget>[
        SizedBox(height: 2.h),
        Container(
          height: 7.h,
          width: 90.w,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF0F2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: <Widget>[
              CountryCodePicker(
                onChanged: (country) {
                  // Handle country code change
                },
                initialSelection: 'भारत',
                favorite: const ['+91', 'भारत'],
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Mobile Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: 5.h,
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
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: _validatePhoneNumber,
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildProgressIndicator(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildCircle(_currentStep >= 0),
        SizedBox(width: 2.w),
        _buildCircle(_currentStep >= 1),
        SizedBox(width: 2.w),
        _buildCircle(_currentStep >= 2),
      ],
    );
  }

  Widget _buildCircle(bool isActive) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D813D),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 30.h,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: const FeatureCard(
                              smallText:
                                  "Recent studies say that every kilo of rice contains 78mg of pesticides",
                              mediumText: "Pesticides",
                              largeText: "78mg",
                              imagePath: 'assets/farmer_spraying.jpg',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Positioned(
                  top: 33.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                    ),
                    child: const Text(
                      'We promise you 100% naturally grown foods',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          topRight: Radius.circular(20.w),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 12.h,
                              ),
                              Image.asset(
                                'assets/person.jpg',
                                width: 20.w,
                                height: 10.h,
                              ),
                              Form(
                                key: _formKey,
                                child: _buildStepContent(),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Text(
                                'By continuing you accept our T&C and Privacy Terms',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_currentStep > 0) {
                                        _currentStep--;
                                      }
                                      if (_currentStep == 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 0.8.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
