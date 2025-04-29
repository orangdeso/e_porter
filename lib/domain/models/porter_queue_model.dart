import 'package:cloud_firestore/cloud_firestore.dart';

class PorterQueueModel {
  final String? id;
  final String userId;
  final bool isAvailable; 
  final DateTime onlineAt;
  final String? idUser; 
  final String? idTransaction; 
  final String? locationPorter; 

  PorterQueueModel({
    this.id,
    required this.userId,
    required this.isAvailable,
    required this.onlineAt,
    this.idUser,
    this.idTransaction,
    this.locationPorter,
  });

  factory PorterQueueModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return PorterQueueModel(
      id: docId ?? json['id'],
      userId: json['userId'] ?? '',
      isAvailable: json['isAvailable'] ?? true, 
      onlineAt: (json['onlineAt'] is Timestamp)
          ? (json['onlineAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(json['onlineAt'] ?? 0),
      idUser: json['idUser'],
      idTransaction: json['idTransaction'],
      locationPorter: json['locationPorter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isAvailable': isAvailable,
      'onlineAt': onlineAt,
      'idUser': idUser,
      'idTransaction': idTransaction,
      'locationPorter': locationPorter,
    };
  }
}
