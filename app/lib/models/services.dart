class Services {
  final String id;
  final String name;
  final String category;

  Services({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'],
      name: json['name'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }
}
