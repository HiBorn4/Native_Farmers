// ignore_for_file: unused_import, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:native_farmers/widgets/custom_shopping_pack.dart';
import 'package:native_farmers/widgets/product_mini.dart';
import 'package:native_farmers/widgets/reorder_product_card.dart';
import 'package:sizer/sizer.dart';

import '../components/add_button.dart';
import '../components/custom_button.dart';
import '../components/custom_dropdown.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  // final List<Map<String, dynamic>> products = [
  //   {
  //     'title': 'Kujipataliya Single Polished',
  //     'category': 'Brown Rice',
  //     'originalPrice': 220,
  //     'sellingPrice': 256,
  //     'imageUrl':
  //         'https://5.imimg.com/data5/SELLER/Default/2022/10/OQ/NQ/SW/71853916/kujipatalia-superfine-desi-rice.webp',
  //   },
  //   // Add more products as needed
  // ];

  // final List<Map<String, dynamic>> products = [
  //   {
  //     'title': 'The Summer Pack',
  //     'category': '4 items',
  //     'imageUrl':
  //         'https://www.sendbestgift.com/assets/images/product/f4d58c8e155b59212e5735c6ec9ddcaa.jpg',
  //   }
  // ];

  // final List<Map<String, dynamic>> products = [
  //   {
  //     'title': 'Banginapalli Mangoes',
  //     'category': '1kg',
  //     'originalPrice': 120,
  //     'sellingPrice': 154,
  //     'imageUrl':
  //         'https://www.agrifarming.in/wp-content/uploads/Banganapalli-Mango-Farming-in-India3.jpg',
  //   },
  //   // Add more products as needed
  // ];

  final List<Map<String, dynamic>> products = [
    {
      'title': 'Pusa Basmathi',
      'weight': 2,
      'quantity': 3,
      'orderedDate': "22-03-2004",
      'imageUrl':
          'https://www.agrifarming.in/wp-content/uploads/Banganapalli-Mango-Farming-in-India3.jpg',
    },
    // Add more products as needed
  ];

  final List<String> categories = ['1 Kg', '2 Kg', '5 Kg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ProductCard(
                      //     title: products[index]['title'],
                      //     category: products[index]['category/'],
                      //     originalPrice: products[index]['originalPrice'],
                      //     sellingPrice: products[index]['sellingPrice'],
                      //     imageUrl: products[index]['imageUrl'],),
                      // CustomShoppingCard(
                      //   title: products[index]['title'],
                      //   items: ["Mangoes"],
                      //   imageUrl: products[index]['imageUrl'],
                      //   width: 100.w,
                      //   height: 10.h,
                      //   borderRadius: 20.sp,
                      // ),
                      // ProductMiniCard(
                      //   title: products[index]['title'],
                      //   category: products[index]['category'],
                      //   originalPrice: products[index]['originalPrice'],
                      //   sellingPrice: products[index]['sellingPrice'],
                      //   imageUrl: products[index]['imageUrl'],
                      //   width: 55,
                      //   height: 28,
                      //   borderRadius: 30,
                      // ),
                      ReorderProductCard(
                        title: products[index]['title'],
                        weight: products[index]['weight'],
                        quantity: products[index]['quantity'],
                        orderedDate: products[index]['orderedDate'],
                        imageUrl: products[index]['imageUrl'],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
