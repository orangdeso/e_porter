import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_porter/presentation/widgets/shimer/skeleton_widget.dart';
import 'package:e_porter/_core/constants/colors.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60.h,
          width: double.infinity,
          color: PrimaryColors.primary800,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    strokeAlign: 1.w,
                    color: GrayColors.gray100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 14,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar shimmer
                        SkeletonWidget(height: 50.h, width: 50.w),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonWidget(height: 16.h, width: 120.w),
                              SizedBox(height: 8.h),
                              SkeletonWidget(height: 12.h, width: 200.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Button shimmer
                    SkeletonWidget(height: 60.h, width: double.infinity),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Carousel shimmer
              SkeletonWidget(height: 140.h, width: double.infinity),
              SizedBox(height: 10.h),

              // Dots indicator shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    4,
                    (index) => Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          child: SkeletonWidget(height: 8.h, width: 8.w),
                        )),
              ),
              SizedBox(height: 32.h),

              // Services title shimmer
              SkeletonWidget(height: 20.h, width: 150.w),
              SizedBox(height: 4.h),
              SkeletonWidget(height: 14.h, width: 250.w),
              SizedBox(height: 16.h),

              // Service cards shimmer
              Row(
                children: [
                  Expanded(child: SkeletonWidget(height: 80.h, width: double.infinity)),
                  SizedBox(width: 16.w),
                  Expanded(child: SkeletonWidget(height: 80.h, width: double.infinity)),
                  SizedBox(width: 16.w),
                  Expanded(child: SkeletonWidget(height: 80.h, width: double.infinity)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
