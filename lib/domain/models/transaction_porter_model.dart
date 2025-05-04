import 'dart:developer';

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
  final RejectionInfo? rejectionInfo;
  final ReassignmentInfo? reassignmentInfo;
  final String? previousTransactionId;
  final bool? isRejected;
  final bool? hasAssignedPorter;

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
    this.rejectionInfo,
    this.reassignmentInfo,
    this.previousTransactionId,
    this.isRejected,
    this.hasAssignedPorter,
  }) : normalizedStatus = _normalizeStatus(status, rejectionInfo);

  static String _normalizeStatus(String status, RejectionInfo? rejectionInfo) {
    if (rejectionInfo != null) {
      return "rejected";
    }

    final lowercaseStatus = status.toLowerCase().trim();

    // Status standar
    if (lowercaseStatus == "pending") return "pending";
    if (lowercaseStatus == "proses") return "proses";
    if (lowercaseStatus == "selesai") return "selesai";
    if (lowercaseStatus == "rejected" || lowercaseStatus == "ditolak") return "rejected";

    // Logic fallback untuk menangani potensi status yang tidak konsisten
    if (lowercaseStatus.contains("pend")) return "pending";
    if (lowercaseStatus.contains("pros")) return "proses";
    if (lowercaseStatus.contains("sele") || lowercaseStatus.contains("done")) return "selesai";
    if (lowercaseStatus.contains("rej") || lowercaseStatus.contains("tol")) return "rejected";

    return "pending";
  }

  factory PorterTransactionModel.fromJson(Map<dynamic, dynamic> json, String id) {
    RejectionInfo? rejectionInfo;
    if (json.containsKey('rejectionInfo')) {
      try {
        final rejectionData = json['rejectionInfo'];
        if (rejectionData is Map) {
          final Map<String, dynamic> safeRejectionData =
              Map<String, dynamic>.from(rejectionData.map((key, value) => MapEntry(key.toString(), value)));

          rejectionInfo = RejectionInfo(
            reason: safeRejectionData['reason']?.toString() ?? 'Tidak ada alasan',
            timestamp: safeRejectionData.containsKey('timestamp')
                ? (safeRejectionData['timestamp'] is int
                    ? DateTime.fromMillisecondsSinceEpoch(safeRejectionData['timestamp'])
                    : DateTime.now())
                : DateTime.now(),
            status: safeRejectionData['status']?.toString() ?? 'rejected',
          );
        }
      } catch (e) {
        log('[Transaction Porter Model] Error parsing rejectionInfo: $e');
        rejectionInfo = RejectionInfo(
          reason: 'Data tidak valid',
          timestamp: DateTime.now(),
          status: 'rejected',
        );
      }
    }

    ReassignmentInfo? reassignmentInfo;
    if (json.containsKey('reassignmentInfo') && json['reassignmentInfo'] != null) {
      try {
        final Map<String, dynamic> reassignmentData;
        if (json['reassignmentInfo'] is Map<String, dynamic>) {
          reassignmentData = json['reassignmentInfo'];
        } else if (json['reassignmentInfo'] is Map) {
          // Convert dynamic map to string map
          reassignmentData = {};
          (json['reassignmentInfo'] as Map).forEach((key, value) {
            reassignmentData[key.toString()] = value;
          });
        } else {
          reassignmentData = {'reason': 'Format tidak valid', 'timestamp': DateTime.now().millisecondsSinceEpoch};
        }
        reassignmentInfo = ReassignmentInfo.fromJson(reassignmentData);
      } catch (e) {
        print('Error parsing reassignmentInfo: $e');
      }
    }

    return PorterTransactionModel(
      id: id,
      kodePorter: json['kodePorter'] ?? '',
      porterUserId: json['porterUserId'] ?? '',
      idPassenger: json['idPassenger'] as String? ?? '',
      locationPassenger: json['locationPassenger'] as String? ?? '',
      locationPorter: json['locationPorter'] as String? ?? '',
      porterOnlineId: json['porterOnlineId'] as String? ?? '',
      status: json['status'] as String? ?? 'Data Not Found',
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
      rejectionInfo: rejectionInfo,
      reassignmentInfo: reassignmentInfo,
      previousTransactionId: json['previousTransactionId'],
      isRejected: json['isRejected'] as bool? ?? false,
      hasAssignedPorter: json['hasAssignedPorter'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'kodePorter': kodePorter,
      'porterUserId': porterUserId,
      'idPassenger': idPassenger,
      'locationPassenger': locationPassenger,
      'locationPorter': locationPorter,
      'porterOnlineId': porterOnlineId,
      'status': status,
      'ticketId': ticketId,
      'transactionId': transactionId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'rejectionInfo': rejectionInfo?.toJson(),
      'reassignmentInfo': reassignmentInfo?.toJson(),
      'previousTransactionId': previousTransactionId,
      'isRejected': isRejected,
      'hasAssignedPorter': hasAssignedPorter,
    };

    if (updatedAt != null) {
      data['updatedAt'] = updatedAt!.millisecondsSinceEpoch;
    }

    if (rejectionInfo != null) {
      data['rejectionInfo'] = rejectionInfo!.toJson();
    }

    return data;
  }

  PorterTransactionModel copyWith({
    String? id,
    String? kodePorter,
    String? porterUserId,
    String? idPassenger,
    String? locationPassenger,
    String? locationPorter,
    String? porterOnlineId,
    String? status,
    String? ticketId,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    RejectionInfo? rejectionInfo,
  }) {
    return PorterTransactionModel(
      id: id ?? this.id,
      kodePorter: kodePorter ?? this.kodePorter,
      porterUserId: porterUserId ?? this.porterUserId,
      idPassenger: idPassenger ?? this.idPassenger,
      locationPassenger: locationPassenger ?? this.locationPassenger,
      locationPorter: locationPorter ?? this.locationPorter,
      porterOnlineId: porterOnlineId ?? this.porterOnlineId,
      status: status ?? this.status,
      ticketId: ticketId ?? this.ticketId,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rejectionInfo: rejectionInfo ?? this.rejectionInfo,
    );
  }
}

class RejectionInfo {
  final String reason;
  final DateTime timestamp;
  final String status;

  RejectionInfo({required this.reason, required this.timestamp, this.status = 'rejected'});

  factory RejectionInfo.fromJson(Map<String, dynamic> json) {
    return RejectionInfo(
      reason: json['reason'] ?? 'Tidak ada alasan',
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      status: json['status'] ?? 'rejected',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status,
    };
  }
}

class ReassignmentInfo {
  final String? previousPorterId;
  final String? rejectionId;
  final String reason;
  final DateTime timestamp;

  ReassignmentInfo({
    this.previousPorterId,
    this.rejectionId,
    required this.reason,
    required this.timestamp,
  });

  factory ReassignmentInfo.fromJson(Map<String, dynamic> json) {
    var rawTimestamp = json['timestamp'];
    DateTime timestamp;

    if (rawTimestamp is Timestamp) {
      timestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is int) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    } else {
      timestamp = DateTime.now(); // Default fallback
    }

    return ReassignmentInfo(
      previousPorterId: json['previousPorterId'],
      rejectionId: json['rejectionId'],
      reason: json['reason'] ?? 'Dialihkan ke porter baru',
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousPorterId': previousPorterId,
      'rejectionId': rejectionId,
      'reason': reason,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
