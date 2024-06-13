import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:sizer/sizer.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;

  const CustomDropdown({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;
  bool _isDropdownOpened = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _selectedValue ?? widget.items[0],
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Changed to black color
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: _selectedValue,
        onChanged: (String? value) {
          setState(() {
            _selectedValue = value;
            _isDropdownOpened = false;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 5.h,
          width: 30.w,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.h),
            border: Border.all(
              color: Colors.black26,
            ),
            color: _isDropdownOpened ? Colors.yellow : Colors.white,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: _isDropdownOpened
              ? const Icon(Icons.keyboard_arrow_up_rounded)
              : const Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 30.sp,
          iconEnabledColor: Colors.black,
          iconDisabledColor: Colors.black,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 20.h,
          width: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_isDropdownOpened ? 14.h : 2.h),
            color: Colors.yellow,
          ),
          offset: Offset(0, 5.h),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 4.h,
        ),
      ),
    );
  }
}
