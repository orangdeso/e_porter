class Airport {
  final String? city;
  final String? code;
  final String? name;

  Airport({required this.city, required this.code, required this.name});

  factory Airport.fromMap(Map<String, dynamic> map) {
    return Airport(
      city: map['city'] as String?,
      code: map['kode'] as String?,
      name: map['name'] as String?,
    );
  }
}
