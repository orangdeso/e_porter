import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityBanner extends StatelessWidget {
  const PriorityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20.w,
            top: -20.h,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: -10.w,
            bottom: -10.h,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.diamond_outlined,
                      color: Colors.white,
                      size: 16.w,
                    ),
                    SizedBox(width: 8.w),
                    TypographyStyles.caption(
                      'PREMIUM SERVICE',
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                TypographyStyles.h6('Prioritas Anda, \nKepuasan Kami', color: Colors.white),
                SizedBox(height: 8.h),
                TypographyStyles.tiny(
                  'Booking mudah, layanan cepat, perjalanan nyaman',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                // SizedBox(height: 16.h),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(20.r),
                //     border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
                //   ),
                //   child: TypographyStyles.tiny('Pesan Sekarang', color: Colors.white, fontWeight: FontWeight.w500),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
