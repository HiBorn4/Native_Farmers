// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:native_farmers/pages/login_screen.dart';
import 'package:native_farmers/widgets/card.dart';
import 'package:sizer/sizer.dart';
import 'home_screen.dart';
import 'dart:async';

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
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);
  final TextEditingController _otpController = TextEditingController();

  late ScrollController _scrollController;
  late Timer _timer;

  late bool serviceEnabled;
  late LocationPermission permission;

  String _phoneNumber = '';
  bool _isPhoneNumberValid = false;
  int _currentStep = 0;
  String? _verificationId;
  String _countryCode = '+91'; // Default country code

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _pincodeController.dispose();
    _progress.dispose();
    _timer.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();

    _phoneController.addListener(() {
      setState(() {
        _phoneNumber = _phoneController.text;
      });
    });
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await Geolocator.requestPermission();
    await Geolocator.isLocationServiceEnabled();
    await _determinePosition();
  }

  void _updateProgress() {
    _progress.value = (_currentStep + 1) / 3;
  }

  Future<void> getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String city = placemark.locality ?? '';
        String locality = placemark.subLocality ?? '';
        String postalCode = placemark.postalCode ?? '';
        print('City: $city');
        print('Locality: $locality');
        print('Postal Code: $postalCode');
      }
    } catch (e) {
      print('Error getting location details: $e');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_scrollController.hasClients) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentScrollPosition = _scrollController.position.pixels;
        double nextScrollPosition = currentScrollPosition + 100.w;

        if (nextScrollPosition >= maxScrollExtent) {
          nextScrollPosition = 0;
        }

        _scrollController.animateTo(
          nextScrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_currentStep == 2) {
        // Request OTP verification
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-resolve scenario
            await _auth.signInWithCredential(credential);
            _saveUserDetails();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification failed: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
            });
            // Move to the OTP verification step
            setState(() {
              _currentStep = 3;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              _verificationId = verificationId;
            });
          },
        );
      }
    }
  }

  Widget _buildOtpVerification() {
    return Column(
      children: [
        TextFormField(
          controller: _otpController,
          decoration: InputDecoration(labelText: 'OTP'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the OTP';
            }
            return null;
          },
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () async {
            if (_verificationId != null) {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId!,
                  smsCode: _otpController.text.trim(),
                );
                await _auth.signInWithCredential(credential);
                _saveUserDetails();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('OTP verification failed: ${e.toString()}'),
                  ),
                );
              }
            }
          },
          child: Text('Verify OTP'),
        ),
      ],
    );
  }

  void _showOtpDialog() {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'OTP',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final otp = otpController.text.trim();
              if (otp.isNotEmpty && _verificationId != null) {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId!,
                  smsCode: otp,
                );
                try {
                  await _auth.signInWithCredential(credential);
                  _saveUserDetails();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('OTP verification failed: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneNumber,
        'pincode': _pincodeController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _detectPincode() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    // await Geocoder.local.findAddressesFromCoordinates(coordinates);

    getLocationDetails(position.latitude, position.longitude);
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
        _phoneNumber = '$_countryCode$phone'; // Prepend country code
        _isPhoneNumberValid = true;
        _updateProgress();
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
      case 3:
        return _buildOtpVerification();
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
    required TextInputType keyboardType,
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
            children: [
              if (_currentStep != 0)
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    radius: 5.w,
                    child: icon,
                  ),
                ),
              if (_currentStep == 0)
                CountryCodePicker(
                  onChanged: (country) {
                    setState(() {
                      _countryCode =
                          country.dialCode ?? '+91'; // Update country code
                    });
                  },
                  initialSelection: 'भारत',
                  favorite: const ['+91', 'भारत'],
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: labelText,
                  ),
                  keyboardType: keyboardType,
                ),
              ),
              if (onButtonPressed != null && _currentStep != 0)
                IconButton(
                  icon: const Icon(Icons.gps_fixed, color: Colors.grey),
                  onPressed: onButtonPressed,
                ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        _buildProgressIndicator(),
        SizedBox(height: 2.h),
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
      ],
    );
  }

  Widget _buildPhoneInput() {
    return _buildInputField(
      controller: _phoneController,
      labelText: 'Mobile Number',
      icon: null,
      onButtonPressed: null,
      onNextPressed: _validatePhoneNumber,
      isLastStep: false,
      keyboardType: TextInputType.phone,
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
          _updateProgress();
          _currentStep = 2;
        });
      },
      isLastStep: false,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildPincodeInput() {
    return _buildInputField(
      controller: _pincodeController,
      labelText: 'Pincode',
      icon: Icon(Icons.location_on, color: Colors.grey, size: 6.w),
      onButtonPressed: _detectPincode,
      onNextPressed: () {
        _register();
        _updateProgress();
      },
      isLastStep: true,
      keyboardType: TextInputType.number,
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
            flex: 2,
            child: Stack(
              children: <Widget>[
                // Scrolling Card
                Container(
                  height: 30.h,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Center(
                      child: ListView.builder(
                        controller: _scrollController,
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
                              imagePath: 'assets/farmer.webp',
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
                  left: 11.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'We promise you 100% naturally grown foods',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Align(
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
                              height: 10.h,
                            ),
                            ValueListenableBuilder<double>(
                              valueListenable: _progress,
                              builder: (context, value, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: CircularProgressIndicator(
                                        value: value,
                                        strokeWidth: 10.0,
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/user.png',
                                      width: 20.w,
                                      height: 10.h,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Form(
                              key: _formKey,
                              child: _buildStepContent(),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            SizedBox(
                              width: 50.w,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'By continuing you accept our ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Colors
                                        .black, // Ensure this matches your theme
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'T&C',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle T&C tap
                                          print('T&C tapped');
                                        },
                                    ),
                                    const TextSpan(
                                      text: ' and ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Privacy Terms',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle Privacy Terms tap
                                          print('Privacy Terms tapped');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
