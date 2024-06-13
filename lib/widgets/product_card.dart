import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../components/add_button.dart';
import '../components/custom_dropdown.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String category;
  final int originalPrice;
  final int sellingPrice;
  final String imageUrl;

  ProductCard({
    Key? key,
    required this.title,
    required this.category,
    required this.originalPrice,
    required this.sellingPrice,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['1 Kg', '2 Kg', '5 Kg'];
    return SizedBox(
      height: 25.h,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.5.h),
                    child: SizedBox(
                      height: 14.h,
                      width: 32.w,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Ensure text alignment
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.category,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '₹${widget.sellingPrice}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            '₹${widget.originalPrice}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomDropdown(
                      items: categories,
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                          icon: _isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30.sp,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 30.sp,
                                ),
                        ),
                        AddButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
