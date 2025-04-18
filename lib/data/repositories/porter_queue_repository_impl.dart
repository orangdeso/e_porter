import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/porter_queue_repository.dart';

import '../../domain/models/porter_queue_model.dart';

class PorterQueueRepositoryImpl implements PorterQueueRepository {
  final FirebaseFirestore _firestore;

  PorterQueueRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> createPorterQueue(String userId) async {
    try {
      log('[PorterRepository] Membuat antrian porter untuk userId: $userId');

      // Periksa apakah porter dengan userId ini sudah ada
      final existingPorter = await getPorterByUserId(userId);
      if (existingPorter != null) {
        log('[PorterRepository] Porter dengan userId: $userId sudah ada di antrian');
        return existingPorter.id!;
      }

      // Buat data porter baru
      final now = DateTime.now();
      final porterData = PorterQueueModel(
        userId: userId,
        isTaken: true,
        onlineAt: now,
      ).toJson();

      // Simpan ke Firestore
      final docRef = await _firestore.collection('porterOnline').add(porterData);

      log('[PorterRepository] Berhasil membuat antrian porter dengan ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      log('[PorterRepository] Error membuat antrian porter: $e');
      throw Exception('Gagal membuat antrian porter: $e');
    }
  }

  @override
  Future<PorterQueueModel?> getPorterByUserId(String userId) async {
    try {
      final snapshot = await _firestore.collection('porterOnline').where('userId', isEqualTo: userId).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        return PorterQueueModel.fromJson(snapshot.docs.first.data(), docId: snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      log('[PorterRepository] Error mendapatkan porter by userId: $e');
      return null;
    }
  }

  @override
  Future<void> deletePorterQueue(String porterId) async {
    try {
      log('[PorterRepository] Menghapus antrian porter dengan ID: $porterId');

      await _firestore.collection('porterOnline').doc(porterId).delete();

      log('[PorterRepository] Berhasil menghapus antrian porter dengan ID: $porterId');
    } catch (e) {
      log('[PorterRepository] Error menghapus antrian porter: $e');
      throw Exception('Gagal menghapus antrian porter: $e');
    }
  }
}
