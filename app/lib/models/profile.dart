class Profile {
   String? id;
   String? fullName;
   String? avatarUrl;
   String? role;
   String? phoneNumber;

  Profile({
     this.id,
     this.fullName,
    this.avatarUrl,
     this.role,
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
