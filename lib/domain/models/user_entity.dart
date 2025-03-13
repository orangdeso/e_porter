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
  final String uid;
  final String? tipeId;
  final String? noId;
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
    required this.uid,
    required this.tipeId,
    required this.noId,
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
      uid: map['uid'] ?? '',
      tipeId: map['tipeId'] ?? '',
      noId: map['noId'] ?? '',
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
      'uid': uid,
      'tipeId': tipeId,
      'noId': noId,
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
  
  UserData copyWith({
    String? uid,
    String? tipeId,
    String? noId,
    String? name,
    String? email,
    String? phone,
    String? birthDate,
    String? gender,
    String? work,
    String? city,
    String? address,
    String? role,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      tipeId: tipeId ?? this.tipeId,
      noId: noId ?? this.noId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      work: work ?? this.work,
      city: city ?? this.city,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }
}

class PassengerModel {
  final String typeId;
  final String noId;
  final String name;
  final String gender;

  PassengerModel({
    required this.typeId,
    required this.noId,
    required this.name,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'typeId': typeId,
      'noId': noId,
      'name': name,
      'gender': gender,
    };
  }

  factory PassengerModel.fromMap(Map<String, dynamic> map) {
    return PassengerModel(
      typeId: map['typeId'] ?? '',
      noId: map['noId'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}
