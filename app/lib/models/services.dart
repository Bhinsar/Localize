class Services {
  String? id;
  String? name;
  String? category;

  Services({this.id, this.name, this.category});

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      category: json['category']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category};
  }
}
