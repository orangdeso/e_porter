import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ForgetPasswordText extends StatelessWidget {
  final VoidCallback onTab;

  const ForgetPasswordText({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTab,
        child: Align(
          alignment: FractionalOffset.centerRight,
          child: TypographyStyles.body(
            'Lupa password?',
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}