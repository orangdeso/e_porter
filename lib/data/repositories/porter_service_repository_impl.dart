// data/repositories/porter_service_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/porter_service_model.dart';
import '../../domain/repositories/porter_service_repository.dart';

class PorterServiceRepositoryImpl implements PorterServiceRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'PorterServices';

  PorterServiceRepositoryImpl({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<PorterServiceModel>> getAllServices() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      final services = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PorterServiceModel.fromJson(data, doc.id);
      }).toList();
      return services;
    } catch (e) {
      throw Exception('Error mengambil daftar layanan porter: $e');
    }
  }

  @override
  Future<List<PorterServiceModel>> getServicesByType(String type) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('availableFor', arrayContains: type)
          .orderBy('sort')
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PorterServiceModel.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error mendapatkan layanan berdasarkan tipe: $e');
    }
  }
}
