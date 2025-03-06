class UserEntity {
  final String uid;
  final String email;

  UserEntity({
    required this.uid,
    required this.email,
  });
}

class UserData {
  final String name;
  final String email;
  final String phone;
  final String birthDate;
  final String gender;
  final String work;
  final String city;
  final String address;
  final String role;

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
    return UserData(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      birthDate: map['birth_date'],
      gender: map['gender'],
      work: map['work'],
      city: map['city'],
      address: map['address'],
      role: map['role'],
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
