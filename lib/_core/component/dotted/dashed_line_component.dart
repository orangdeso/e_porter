import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDashedLine extends StatelessWidget {
  final double width;
  final double height;
  final Axis axis;
  final Color dashColor;
  // final double? dashWidth;
  // final double? dashSpace;

  const CustomDashedLine({
    Key? key,
    this.width = double.infinity,
    this.height = 0,
    this.axis = Axis.horizontal,
    this.dashColor = GrayColors.gray300,
    // this.dashWidth,
    // this.dashSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedDashedLine(
      height: height,
      width: width,
      axis: axis,
      dashColor: dashColor,
      // dashWidth: dashWidth,
      // dashSpace: dashSpace,
    );
  }
}
