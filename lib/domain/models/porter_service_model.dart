class PorterServiceModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final List<String> tersediaUntuk;
  final int sort;

  PorterServiceModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.tersediaUntuk,
    required this.sort,
  });

  factory PorterServiceModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    List<String> parseTersediaUntuk(dynamic tersediaUntuk) {
      if (tersediaUntuk is List) {
        return tersediaUntuk.map((item) => item.toString()).toList();
      } else if (tersediaUntuk is Map) {
        return tersediaUntuk.entries.map((entry) => entry.value.toString()).toList();
      }
      return [];
    }

    return PorterServiceModel(
      id: docId ?? json['id'],
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      tersediaUntuk: parseTersediaUntuk(json['availableFor']),
      sort: json['sort'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'availableFor': tersediaUntuk,
      'sort': sort,
    };
  }

  PorterServiceModel copyWith({
    String? id,
    String? name,
    int? price,
    String? description,
    List<String>? tersediaUntuk,
    int? sort,
  }) {
    return PorterServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      tersediaUntuk: tersediaUntuk ?? this.tersediaUntuk,
      sort: sort ?? this.sort,
    );
  }
}
