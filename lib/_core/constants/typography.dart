import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyStyles extends StatelessWidget {
  static const String fontFamily = 'DMSans';

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxlines;
  final Color? color;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;

  // final TextDirection? textDirection;
  // final Locale? locale;
  // final bool? softWrap;
  // final TextScaler? textScaler;
  // final String? semanticsLabel;
  // final TextWidthBasis? textWidthBasis;
  // final TextHeightBehavior? textHeightBehavior;
  // final Color? selectionColor;

  TypographyStyles.h1(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.letterSpacing,
  }) : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 80.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.h2(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 60.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.h3(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 40.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.h4(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 30.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.h5(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 24.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.h6(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 20.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.body(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing,})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 16.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.caption(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 14.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.small(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 12.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  TypographyStyles.tiny(this.text,
      {super.key,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.maxlines,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.height,
      this.letterSpacing})
      : style = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize ?? 10.sp,
          fontWeight: fontWeight ?? FontWeight.w900,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? 0.2,
        );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxlines,
    );
  }
}
