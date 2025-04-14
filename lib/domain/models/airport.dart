class Airport {
  final String? id;
  final String? city;
  final String? code;
  final String? name;

  Airport({this.id, required this.city, required this.code, required this.name});

  factory Airport.fromMap(Map<String, dynamic> map, String documentId) {
    return Airport(
      id: documentId,
      city: map['city'] as String?,
      code: map['kode'] as String?,
      name: map['name'] as String?,
    );
  }
}
