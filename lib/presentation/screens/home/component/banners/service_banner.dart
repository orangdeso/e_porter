import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceBanner extends StatelessWidget {
  const ServiceBanner({super.key});

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
            Color(0xFFEA580C),
            Color(0xFFF97316),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: -20.h,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TypographyStyles.caption('E-Porter', color: Colors.white),
                      ),
                      SizedBox(height: 6.h),
                      TypographyStyles.h6('Layanan Porter\nProfessional', color: Colors.white),
                      SizedBox(height: 8.h),
                      TypographyStyles.tiny(
                        'Nikmati kemudahan perjalanan dengan bantuan porter terpercaya',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    size: 30.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
