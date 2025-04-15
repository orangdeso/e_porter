import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/airport.dart';
import '../../domain/repositories/airport_repository.dart';

class AirportRepositoryImpl implements AirportRepository {
  final FirebaseFirestore firestore;

  AirportRepositoryImpl({required this.firestore});

  @override
  Future<List<Airport>> getAirports() async {
    final snapshot = await firestore.collection('bandara').get();
    return snapshot.docs
        .map((doc) => Airport.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<Airport?> getAirportsById(String id) async {
    try {
      final doc = await firestore.collection('bandara').doc(id).get();
      
      if (doc.exists) {
        return Airport.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      log('Error fetching airport by ID: $e');
      return null;
    }
  }
}