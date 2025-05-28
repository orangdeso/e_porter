// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/profil_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      log("Passenger doc id: ${docRef.id}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PassengerModel>> getPassengerById(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(userId).collection('passenger').get();
      return querySnapshot.docs
          .map((doc) => PassengerModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePassenger({
    required String userId,
    required String passengerId,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).collection('passenger').doc(passengerId).delete();
      log("Passenger deleted with ID: $passengerId");
    } catch (e) {
      log("Error deleting passenger: $e");
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
  Future<void> updatePassenger({
    required String userId,
    required String passengerId,
    required PassengerModel passenger,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('passenger')
          .doc(passengerId)
          .update(passenger.toMap());
      log("Passenger updated with ID: $passengerId");
    } catch (e) {
      log("Error updating passenger: $e");
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

  @override
  Future<void> changeNoId({
    required String oldPassword,
    required String typeId,
    required String noId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final existingUserQuery =
        await _firestore.collection('users').where('typeId', isEqualTo: typeId).where('noId', isEqualTo: noId).get();

    if (existingUserQuery.docs.isNotEmpty) {
      final isCurrentUser = existingUserQuery.docs.any((doc) => doc.id == user.uid);
      if (!isCurrentUser) {
        throw Exception("Nomor ID sudah digunakan oleh pengguna lain");
      }
    }

    final allUsersQuery = await _firestore.collection('users').get();
    for (final userDoc in allUsersQuery.docs) {
      final passengerQuery = await _firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('passenger')
          .where('typeId', isEqualTo: typeId)
          .where('noId', isEqualTo: noId)
          .get();
      if (passengerQuery.docs.isNotEmpty) {
        throw Exception("Nomor ID sudah digunakan oleh pengguna lain");
      }
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await _firestore.collection('users').doc(user.uid).update({
      'typeId': typeId,
      'noId': noId,
    });
  }

  @override
  Future<void> updateUserData(UserData userData) async {
    try {
      if (userData.uid.isEmpty) {
        throw Exception("User ID tidak boleh kosong");
      }

      await _firestore.collection('users').doc(userData.uid).update({
        'name': userData.name,
        'birth_date': userData.birthDate,
        'gender': userData.gender,
        'work': userData.work,
        'city': userData.city,
        'address': userData.address
      });

      log("Data pengguna berhasil diperbarui untuk ID: ${userData.uid}");
    } catch (e) {
      log("Error saat memperbarui data pengguna: $e");
      rethrow;
    }
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
