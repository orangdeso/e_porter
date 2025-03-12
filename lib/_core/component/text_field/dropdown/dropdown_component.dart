import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownComponent extends StatefulWidget {
  final String? value;
  final Function(String?) onChanged;
  final String hintText;

  const DropdownComponent({
    Key? key,
    this.value,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  State<DropdownComponent> createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  final List<String> items = ["KTP", "Paspor"];
  String? selectedValue;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.14,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontFamily: 'DMsans',
                  fontSize: 16.sp,
                  color: GrayColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          hint: Text(
            widget.hintText,
            style: TextStyle(
              fontFamily: 'DMsans',
              fontSize: 16.sp,
              color: GrayColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          onMenuStateChange: (isOpen) {
            setState(() {
              _isMenuOpen = isOpen;
            });
          },
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
            widget.onChanged(newValue);
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(left: 10.w, right: 16.w, top: 4.h, bottom: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: _isMenuOpen ? PrimaryColors.primary800 : GrayColors.gray200),
              color: Colors.white,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            elevation: 1,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
          ),
        ),
      ),
    );
  }
}
