import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductMiniCard extends StatefulWidget {
  final String title;
  final String category;
  final int originalPrice;
  final int sellingPrice;
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const ProductMiniCard({
    Key? key,
    required this.title,
    required this.category,
    required this.originalPrice,
    required this.sellingPrice,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.borderRadius,
  }) : super(key: key);

  @override
  _ProductMiniCardState createState() => _ProductMiniCardState();
}

class _ProductMiniCardState extends State<ProductMiniCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width.w,
      height: widget.height.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius.sp),
        child: Card(
          elevation: 10,
          shadowColor: const Color(0xADC1CC),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.sp),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.5.h),
                      child: SizedBox(
                        height: 15.h,
                        width: double.infinity,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.category,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 4.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '₹${widget.sellingPrice}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            '₹${widget.originalPrice}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      SizedBox(
                        width: 23.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
