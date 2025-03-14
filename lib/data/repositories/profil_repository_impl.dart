import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/profil_repository.dart';
import '../../_core/service/logger_service.dart';
import '../../domain/models/user_entity.dart';

class ProfilRepositoryImpl implements ProfilRepository {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createPassenger({
    required String userId,
    required PassengerModel passenger,
  }) async {
      try {
        DocumentReference docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('passenger')
          .add(passenger.toMap());
        logger.d("Passenger doc id: ${docRef.id}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PassengerModel>> getPassengerById(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('passenger')
        .get();
      return querySnapshot.docs
        .map((doc) => PassengerModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    } catch (e) {
      rethrow;
    }
  }
}