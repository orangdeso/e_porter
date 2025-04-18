import 'package:cloud_firestore/cloud_firestore.dart';

class PorterQueueModel {
  final String? id;
  final String userId;
  final bool isTaken;
  final DateTime onlineAt;

  PorterQueueModel({
    this.id,
    required this.userId,
    required this.isTaken,
    required this.onlineAt,
  });

  factory PorterQueueModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return PorterQueueModel(
      id: docId ?? json['id'],
      userId: json['userId'] ?? '',
      isTaken: json['isTaken'] ?? false,
      onlineAt: (json['onlineAt'] is Timestamp) 
          ? (json['onlineAt'] as Timestamp).toDate() 
          : DateTime.fromMillisecondsSinceEpoch(json['onlineAt'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isTaken': isTaken,
      'onlineAt': onlineAt,
    };
  }
}