import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/presentation/widgets/shimer/skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePorterShimmer extends StatelessWidget {
  const HomePorterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: const Offset(0, 4),
                  blurRadius: 14,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24.r,
                  child: SkeletonWidget(),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    SkeletonWidget(height: 16.h, width: 120.w),
                    SizedBox(height: 6.h),
                    SkeletonWidget(height: 12.h, width: 200.w),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerTitle(context),
                    SkeletonWidget(
                      width: MediaQuery.of(context).size.width * 0.21,
                      height: 24.h,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildShimmerCard(context),
                SizedBox(height: 32.h),
                _buildShimmerTitle(context),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildShimmerCard(context)),
                    SizedBox(width: 16.w),
                    Expanded(child: _buildShimmerCard(context)),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildShimmerCard(context)),
                    SizedBox(width: 16.w),
                    Expanded(child: _buildShimmerCard(context)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShimmerTitle(BuildContext context) {
    return SkeletonWidget(
      width: MediaQuery.of(context).size.width * 0.51,
      height: 24.h,
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return CustomeShadowCotainner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonWidget(
            height: MediaQuery.of(context).size.width * 0.14,
            width: MediaQuery.of(context).size.width * 0.14,
          ),
          SizedBox(height: 10.h),
          SkeletonWidget(
            height: 20.h,
            width: MediaQuery.of(context).size.width * 0.34,
          ),
          SizedBox(height: 10.h),
          SkeletonWidget(
            height: 14.h,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
        ],
      ),
    );
  }
}
