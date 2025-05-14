import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String idBooking;
  final String ticketId;
  final String flightId;
  final double amount;
  final String method;
  final String status;
  final String? proofUrl;
  final DateTime createdAt;
  final DateTime expiryTime;
  final int passenger;
  final Map<String, dynamic> flightDetails;
  final Map<String, dynamic> bandaraDetails;
  final Map<String, dynamic>? porterServiceDetails;
  final Map<String, dynamic> userDetails;
  final List<Map<String, dynamic>> passengerDetails;
  final List<String> numberSeat;

  TransactionModel({
    required this.id,
    required this.idBooking,
    required this.ticketId,
    required this.flightId,
    required this.amount,
    required this.method,
    required this.status,
    this.proofUrl,
    required this.createdAt,
    required this.expiryTime,
    required this.passenger,
    required this.flightDetails,
    required this.bandaraDetails,
    this.porterServiceDetails,
    required this.userDetails,
    required this.passengerDetails,
    required this.numberSeat,
  });

  DateTime get departureDate => (flightDetails['departureTime'] is int)
      ? DateTime.fromMillisecondsSinceEpoch(flightDetails['departureTime'] as int)
      : DateTime.now();

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime getDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is DateTime) {
        return value;
      } else {
        return DateTime.now();
      }
    }

    List<Map<String, dynamic>> convertToMapList(dynamic list) {
      if (list == null) return [];
      if (list is List) {
        return list.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList();
      }
      return [];
    }

    List<String> convertToStringList(dynamic list) {
      if (list == null) return [];
      if (list is List) {
        return list.map((item) => item.toString()).toList();
      }
      return [];
    }

    return TransactionModel(
      id: json['id'] ?? '',
      idBooking: json['idBooking'] ?? '',
      ticketId: json['ticketId'] ?? '',
      flightId: json['flightId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      method: json['method'] ?? '',
      status: json['status'] ?? 'pending',
      proofUrl: json['proofUrl'],
      createdAt: getDateTime(json['createdAt']),
      expiryTime: getDateTime(json['expiryTime']),
      passenger: json['passenger'] ?? 0,
      flightDetails: json['flightDetails'] ?? {},
      bandaraDetails: json['bandaraDetails'] ?? {},
      porterServiceDetails: json['porterServiceDetails'],
      userDetails: json['userDetails'] ?? {},
      passengerDetails: convertToMapList(json['passengerDetails']),
      numberSeat: convertToStringList(json['numberSeat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBooking': idBooking,
      'ticketId': ticketId,
      'flightId': flightId,
      'amount': amount,
      'method': method,
      'status': status,
      'proofUrl': proofUrl,
      'createdAt': createdAt,
      'expiryTime': expiryTime,
      'passenger': passenger,
      'flightDetails': flightDetails,
      'bandaraDetails': bandaraDetails,
      'porterServiceDetails': porterServiceDetails,
      'userDetails': userDetails,
      'passengerDetails': passengerDetails,
      'numberSeat': numberSeat,
    };
  }
}
