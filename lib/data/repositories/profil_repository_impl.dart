// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/profil_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      DocumentReference docRef =
          await _firestore.collection('users').doc(userId).collection('passenger').add(passenger.toMap());
      logger.d("Passenger doc id: ${docRef.id}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PassengerModel>> getPassengerById(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(userId).collection('passenger').get();
      return querySnapshot.docs.map((doc) => PassengerModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserData> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception("User with id $userId not found");
      }
      return UserData.fromMap(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> changePhone({
    required String oldPassword,
    required String newPhone,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await _firestore.collection('users').doc(user.uid).update({'phone': newPhone});
  }

  // @override
  // Future<void> changeEmail({
  //   required String oldPassword,
  //   required String newEmail,
  // }) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) throw Exception("User belum login");

  //   try {
  //     final cred = EmailAuthProvider.credential(
  //       email: user.email!,
  //       password: oldPassword,
  //     );
  //     await user.reauthenticateWithCredential(cred);
  //     await user.updateEmail(newEmail);
  //     await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'email': newEmail});

  //     await user.sendEmailVerification();

  //     log("Email berhasil diperbarui ke: $newEmail");
  //     log("Email verifikasi telah dikirim");
  //   } catch (e) {
  //     log("Error pada changeEmail: $e");
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> changeEmail({
  //   required String oldPassword,
  //   required String newEmail,
  // }) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) throw Exception("User belum login");

  //   // re-authenticate
  //   final cred = EmailAuthProvider.credential(
  //     email: user.email!,
  //     password: oldPassword,
  //   );
  //   await user.reauthenticateWithCredential(cred);

  //   // gunakan verifyBeforeUpdateEmail (ini kirim link + set newEmail di backend)
  //   await user.verifyBeforeUpdateEmail(
  //     newEmail,
  //     ActionCodeSettings(
  //       url: 'https://eporter.page.link/verifyEmail',
  //       handleCodeInApp: true,
  //       androidPackageName: 'com.example.e_porter',
  //       androidInstallApp: true,
  //       androidMinimumVersion: '1',
  //       dynamicLinkDomain: 'eporter.page.link',
  //     ),
  //   );
  // }
}
