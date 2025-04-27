// domain/models/transaction_porter_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PorterTransactionModel {
  final String id;
  final String kodePorter;
  final String porterUserId;
  final String idPassenger;
  final String locationPassenger;
  final String locationPorter;
  final String porterOnlineId;
  final String status;
  final String normalizedStatus;
  final String ticketId;
  final String transactionId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PorterTransactionModel({
    required this.id,
    required this.kodePorter,
    this.porterUserId = '',
    required this.idPassenger,
    required this.locationPassenger,
    required this.locationPorter,
    required this.porterOnlineId,
    required this.status,
    required this.ticketId,
    required this.transactionId,
    required this.createdAt,
    this.updatedAt,
  }) : normalizedStatus = _normalizeStatus(status);

  // Simplify status normalization since we only have 3 possible statuses
  static String _normalizeStatus(String status) {
    final lowercaseStatus = status.toLowerCase().trim();

    if (lowercaseStatus == "pending") return "pending";
    if (lowercaseStatus == "proses") return "proses";
    if (lowercaseStatus == "selesai") return "selesai";

    // Default fallback logic for potentially inconsistent data
    if (lowercaseStatus.contains("pend")) return "pending";
    if (lowercaseStatus.contains("pros")) return "proses";
    if (lowercaseStatus.contains("sele") || lowercaseStatus.contains("done")) return "selesai";

    return "pending"; // Default to pending if unknown status
  }

  factory PorterTransactionModel.fromJson(Map<dynamic, dynamic> json, String id) {
    return PorterTransactionModel(
      id: id,
      kodePorter: json['kodePorter'] ?? '',
      porterUserId: json['porterUserId'] ?? '',
      idPassenger: json['idPassenger'] as String? ?? '',
      locationPassenger: json['locationPassenger'] as String? ?? '',
      locationPorter: json['locationPorter'] as String? ?? '',
      porterOnlineId: json['porterOnlineId'] as String? ?? '',
      status: json['status'] as String? ?? 'Data Not Fount',
      ticketId: json['ticketId'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      createdAt: json['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : (json['createdAt'] is Timestamp)
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'])
              : (json['updatedAt'] is DateTime ? json['updatedAt'] : null))
          : null,
    );
  }
}
