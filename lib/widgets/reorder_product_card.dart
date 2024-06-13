import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReorderProductCard extends StatefulWidget {
  final String title;
  final int weight;
  final int quantity;
  final String orderedDate;
  final String imageUrl;

  const ReorderProductCard({
    Key? key,
    required this.title,
    required this.weight,
    required this.quantity,
    required this.orderedDate,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ReorderProductCardState createState() => _ReorderProductCardState();
}

class _ReorderProductCardState extends State<ReorderProductCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17.3.h,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(2.5.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.5.h),
                    child: SizedBox(
                      height: 14.h,
                      width: 30.w,
                      child: Image.network(
                        widget.imageUrl, // Placeholder image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SizedBox(
                    width: 57.w,
                    child: Column(
                      // crossAxisAlignment:
                      //     CrossAxisAlignment.start, // Ensure text alignment
                      children: <Widget>[
                        SizedBox(
                          height: 4.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 17.w,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // Handle 3-dot menu press
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${widget.weight} Kg",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.black,
                              size: 3.sp,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              '${widget.quantity} Units',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.black,
                              size: 17.sp,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              '${widget.orderedDate}',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 1.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.sp),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // _showCounter = true;
                                    // _counter = 1; // Start with 1 when the button is first pressed
                                  });
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Re-order',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
