import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double borderRadius;
  final Color color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 80.0,
    this.borderRadius = 8.0,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
