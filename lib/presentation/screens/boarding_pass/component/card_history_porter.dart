import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardHistoryPorter extends StatelessWidget {
  final String namePassenger;
  final String tlpnPassenger;
  final String? porter1;
  final String? porter2;
  final String? porter3;
  final String lokasiPassenger;
  final String status;
  final String date;
  final String time;
  final Color? statusColor;
  final String? price;
  final VoidCallback? onTap;
  final String? bookingId;

  const CardHistoryPorter({
    Key? key,
    required this.namePassenger,
    required this.tlpnPassenger,
    this.porter1,
    this.porter2,
    this.porter3,
    required this.lokasiPassenger,
    required this.status,
    required this.date,
    required this.time,
    this.statusColor,
    this.price,
    this.onTap,
    this.bookingId,
  }) : super(key: key);

  bool get _shouldShowPorters {
    if (porter1 == null && porter2 == null && porter3 == null) return false;
    return (porter1?.isNotEmpty ?? false) || (porter2?.isNotEmpty ?? false) || (porter3?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: CustomeShadowCotainner(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Divider(height: 16.h, thickness: 1, color: GrayColors.gray100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusAvatar(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPassengerInfo(),
                        SizedBox(height: 6.h),
                        if (_shouldShowPorters) ...[
                          _buildPorterInfo(),
                          SizedBox(height: 6.h),
                        ],
                        _buildLocationInfo(),
                        SizedBox(height: 6.h),
                        _buildPriceInfo(),
                        SizedBox(height: 6.h),
                        _buildDateAndTimeInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (bookingId != null) ...[
          Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 14.sp,
                color: GrayColors.gray500,
              ),
              SizedBox(width: 4.w),
              TypographyStyles.caption(
                'ID: $bookingId',
                color: GrayColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ] else ...[
          SizedBox(width: 4.w),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statusColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(),
                size: 12.sp,
                color: statusColor,
              ),
              SizedBox(width: 4.w),
              TypographyStyles.caption(
                status,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAvatar() {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: statusColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
      child: Icon(
        _getStatusIcon(),
        color: statusColor,
        size: 20.sp,
      ),
    );
  }

  Widget _buildPassengerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypographyStyles.body(
          namePassenger,
          color: GrayColors.gray800,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              size: 14.sp,
              color: GrayColors.gray400,
            ),
            SizedBox(width: 4.w),
            TypographyStyles.small(
              tlpnPassenger,
              color: GrayColors.gray500,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPorterInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: PrimaryColors.primary50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: PrimaryColors.primary100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypographyStyles.caption(
            'Layanan Porter:',
            color: PrimaryColors.primary800,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              if (porter1 != null && porter1!.isNotEmpty) _buildPorterChip(porter1!),
              if (porter2 != null && porter2!.isNotEmpty) _buildPorterChip(porter2!),
              if (porter3 != null && porter3!.isNotEmpty) _buildPorterChip(porter3!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPorterChip(String porterName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: PrimaryColors.primary200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.luggage_outlined,
            size: 12.sp,
            color: PrimaryColors.primary700,
          ),
          SizedBox(width: 4.w),
          TypographyStyles.caption(
            porterName,
            color: PrimaryColors.primary700,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 24.sp,
          color: GrayColors.gray500,
        ),
        SizedBox(width: 4.w),
        TypographyStyles.caption(
          lokasiPassenger,
          color: GrayColors.gray600,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  // Info Harga
  Widget _buildPriceInfo() {
    if (price == null) return SizedBox.shrink();

    return Row(
      children: [
        Icon(
          Icons.paid_outlined,
          size: 14.sp,
          color: GrayColors.gray500,
        ),
        SizedBox(width: 4.w),
        TypographyStyles.body(
          price!,
          color: PrimaryColors.primary800,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  // Info Tanggal dan Waktu
  Widget _buildDateAndTimeInfo() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14.sp,
          color: GrayColors.gray400,
        ),
        SizedBox(width: 4.w),
        TypographyStyles.small(
          date,
          color: GrayColors.gray500,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.access_time_outlined,
          size: 14.sp,
          color: GrayColors.gray400,
        ),
        SizedBox(width: 4.w),
        TypographyStyles.small(
          time,
          color: GrayColors.gray500,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  // Mendapatkan icon berdasarkan status
  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'proses':
        return Icons.directions_run;
      case 'selesai':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}
