import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isNoIdUnique(String userId, String noId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('passenger')
      .where('noId', isEqualTo: noId)
      .get();
  return querySnapshot.docs.isEmpty;
}
