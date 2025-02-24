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
        .map((doc) => Airport.fromMap(doc.data()))
        .toList();
  }
}