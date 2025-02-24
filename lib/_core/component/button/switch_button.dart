import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const SwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = PrimaryColors.primary800,
    this.inactiveColor = GrayColors.gray200,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: value,
      onToggle: onChanged,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      width: 40.w,
      height: 24.h,
      toggleSize: 16.0,
    );
  }
}
