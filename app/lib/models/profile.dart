class Profile {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String? phoneNumber;

  Profile({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.phoneNumber,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }
}
