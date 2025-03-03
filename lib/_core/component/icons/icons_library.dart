import 'package:e_porter/_core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomeIcons {
  static const String _iconPath = 'assets/icons/';

  static SvgPicture getIcon(
    String fileName, {
    double? size,
    Color? color,
  }) {
    return SvgPicture.asset(
      '$_iconPath$fileName.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? PrimaryColors.primary800,
        BlendMode.srcIn,
      ),
      fit: BoxFit.contain,
    );
  }

  static SvgPicture AccountOutline({double? size, Color? color}) => getIcon('ic_account', color: color);
  static SvgPicture CalendarOutline({double? size, Color? color}) => getIcon('ic_calendar', color: color);
  static SvgPicture DataTransferOutline({double? size, Color? color}) => getIcon('ic_data_transfer', color: color);
  static SvgPicture EmailOutline({double? size, Color? color}) => getIcon('ic_email', color: color);
  static SvgPicture FlightSeatOutline({double? size, Color? color}) => getIcon('ic_flight_seat', color: color);
  static SvgPicture LeftOutline({double? size, Color? color}) => getIcon('ic_left', color: color);
  static SvgPicture RightOutline({double? size, Color? color}) => getIcon('ic_right', color: color);
  static SvgPicture LessThanOutline({double? size, Color? color}) => getIcon('ic_less_than', color: color);
  static SvgPicture MoreThanOutline({double? size, Color? color}) => getIcon('ic_more_than', color: color);
  static SvgPicture NotificationOutline({double? size, Color? color}) => getIcon('ic_notification', color: color);
  static SvgPicture PadLockOutline({double? size, Color? color}) => getIcon('ic_padlock', color: color);
  static SvgPicture PassengerOutline({double? size, Color? color}) => getIcon('ic_passenger', color: color);
  static SvgPicture PlaneLeftOutline({double? size, Color? color}) => getIcon('ic_plane_left', color: color);
  static SvgPicture PlaneRightOutline({double? size, Color? color}) => getIcon('ic_plane_right', color: color);
  static SvgPicture SentOutline({double? size, Color? color}) => getIcon('ic_notification', color: color);
  static SvgPicture SearchOutline({double? size, Color? color}) => getIcon('ic_search', color: color);
  static SvgPicture EditOutline({double? size, Color? color}) => getIcon('ic_edit', color: color);
  static SvgPicture OrderHistoryOutline({double? size, Color? color}) => getIcon('ic_order_history', color: color);
  static SvgPicture AirplaneLandingOutline({double? size, Color? color}) => getIcon('ic_airplane_landing', color: color);
  static SvgPicture AirplaneTakeOffOutline({double? size, Color? color}) => getIcon('ic_airplane_take_off', color: color);
  static SvgPicture TransitOutline({double? size, Color? color}) => getIcon('ic_transit', color: color);
  static SvgPicture ProtectOutline({double? size, Color? color}) => getIcon('ic_protect', color: color);

  static SvgPicture FlightSeatFilled({double? size, Color? color}) => getIcon('ic_flight_seat_filled', color: color);
  static SvgPicture PlaneRightFilled({double? size, Color? color}) => getIcon('ic_plane_filled', color: color);
}
