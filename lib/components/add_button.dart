import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  int _counter = 0;
  bool _showCounter = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.w,
      height: 5.h,
      child: _showCounter
          ? Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.h), // Circular border
              ),
              child: Padding(
                padding: EdgeInsets.all(0.4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_counter > 0) _counter--;
                            if (_counter == 0) _showCounter = false;
                          });
                        },
                        iconSize: 13.sp,
                      ),
                    ),
                    Text(
                      '$_counter',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _counter++;
                          });
                        },
                        iconSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.h),
                ),
              ),
              onPressed: () {
                setState(() {
                  _showCounter = true;
                  _counter = 1; // Start with 1 when the button is first pressed
                });
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ), // Add some spacing between the icon and the text
                  Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
