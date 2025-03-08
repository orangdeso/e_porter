import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uid;
  final String email;

  UserEntity({
    required this.uid,
    required this.email,
  });
}

class UserData {
  final String? name;
  final String? email;
  final String? phone;
  final String? birthDate;
  final String? gender;
  final String? work;
  final String? city;
  final String? address;
  final String? role;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.work,
    required this.city,
    required this.address,
    required this.role,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    final timestamp = map['birth_date'];
    String? birthDateString;

    if (timestamp is Timestamp) {
      // Konversi ke DateTime lalu ke String (format bebas)
      birthDateString = timestamp.toDate().toIso8601String();
    } else if (timestamp is String) {
      // Kalau sudah String, langsung pakai
      birthDateString = timestamp;
    }

    return UserData(
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      birthDate: birthDateString,
      gender: map['gender'] as String?,
      work: map['work'] as String?,
      city: map['city'] as String?,
      address: map['address'] as String?,
      role: map['role'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birth_date': birthDate,
      'gender': gender,
      'work': work,
      'city': city,
      'address': address,
      'role': role,
    };
  }
}
