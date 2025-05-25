import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioButtonGender extends StatelessWidget {
  final String value;
  final String label;
  final ValueNotifier<String> selectedGender;

  RadioButtonGender({
    Key? key,
    required this.value,
    required this.label,
    required this.selectedGender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedGender,
      builder: (context, selected, child) {
        return Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selected,
              activeColor: PrimaryColors.primary800,
              onChanged: (val) {
                selectedGender.value = val!;
              },
            ),
            SizedBox(width: 10.w),
            TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500)
          ],
        );
      },
    );
  }
}
