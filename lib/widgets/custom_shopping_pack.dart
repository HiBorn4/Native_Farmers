import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomShoppingCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final String imageUrl;
  final String title;
  final List<String> items;

  CustomShoppingCard({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.imageUrl,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        elevation: 4,
        shadowColor: Color(0xADC1CC),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1.5.h),
                      child: SizedBox(
                        height: 8.h,
                        width: 18.w,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items
                              .map((item) => Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
