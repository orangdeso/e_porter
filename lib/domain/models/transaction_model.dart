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
  final Map<String, dynamic> flightDetails;
  final Map<String, dynamic> bandaraDetails;
  final Map<String, dynamic>? porterServiceDetails;
  final Map<String, dynamic> userDetails;
  final int passenger;

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
    required this.flightDetails,
    required this.bandaraDetails,
    this.porterServiceDetails,
    required this.userDetails,
    required this.passenger,
  });

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
      flightDetails: json['flightDetails'] ?? {},
      bandaraDetails: json['bandaraDetails'] ?? {},
      porterServiceDetails: json['porterServiceDetails'],
      userDetails: json['userDetails'] ?? {},
      passenger: json['passenger'] ?? 0,
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
      'flightDetails': flightDetails,
      'bandaraDetails': bandaraDetails,
      'porterServiceDetails': porterServiceDetails,
      'userDetails': userDetails,
      'passenger': passenger,
    };
  }
}
