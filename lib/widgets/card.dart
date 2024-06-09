import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FeatureCard extends StatelessWidget {
  final String smallText;
  final String mediumText;
  final String largeText;
  final String imagePath;

  const FeatureCard({
    Key? key,
    required this.smallText,
    required this.mediumText,
    required this.largeText,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w, // Adjust the width as needed
      decoration: BoxDecoration(
        color: Colors
            .greenAccent.shade400, // Provide the color inside the BoxDecoration
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 1.h,
          left: 4.5.w,
          right: 3.w,
          bottom: 1.h,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Text(
                    smallText,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  mediumText,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
                Text(
                  largeText,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Image.asset(
                imagePath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
