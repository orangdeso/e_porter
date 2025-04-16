import 'package:intl/intl.dart';

class DateFormatterHelper {
  static String formatFlightTime(dynamic timeValue) {
    if (timeValue == null) return "";

    if (timeValue is int) {
      return DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(timeValue));
    } else if (timeValue is String) {
      return timeValue;
    }

    return "";
  }

  static String formatFlightDate(dynamic timeValue) {
    if (timeValue == null) return "";

    if (timeValue is int) {
      return DateFormat("EEE, d MMM").format(DateTime.fromMillisecondsSinceEpoch(timeValue));
    }

    return "";
  }

  static String calculateFlightDuration(dynamic departureTime, dynamic arrivalTime) {
    if (departureTime == null || arrivalTime == null) return "";

    DateTime? departure;
    DateTime? arrival;

    if (departureTime is int) {
      departure = DateTime.fromMillisecondsSinceEpoch(departureTime);
    }

    if (arrivalTime is int) {
      arrival = DateTime.fromMillisecondsSinceEpoch(arrivalTime);
    }

    if (departure == null || arrival == null) return "";

    final difference = arrival.difference(departure);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      if (minutes > 0) {
        return "${hours}j ${minutes}m";
      } else {
        return "${hours}j";
      }
    } else {
      return "${minutes}m";
    }
  }
}
