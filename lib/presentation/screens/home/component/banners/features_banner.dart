import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturesBanner extends StatelessWidget {
  const FeaturesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF059669), // Emerald 600
            Color(0xFF10B981), // Emerald 500
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20.w,
            top: -10.h,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    TypographyStyles.body(
                      'Fitur Unggulan',
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _buildFeatureItem('Fast Track', Icons.directions_run),
                    SizedBox(width: 16.w),
                    _buildFeatureItem('Porter VIP', Icons.verified_user),
                    SizedBox(width: 16.w),
                    _buildFeatureItem('Transit', Icons.sync_alt),
                  ],
                ),
                SizedBox(height: 10.h),
                TypographyStyles.tiny(
                  'Nikmati layanan premium untuk perjalanan Anda',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 16.w,
            ),
            SizedBox(height: 4.h),
            TypographyStyles.tiny(
              text,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
