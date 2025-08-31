import 'package:app/models/services.dart';

class GeoLocation {
  final double latitude;
  final double longitude;

  GeoLocation({required this.latitude, required this.longitude});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as List;
    return GeoLocation(
      longitude: coordinates[0].toDouble(),
      latitude: coordinates[1].toDouble(),
    );
  }
}

class ProviderDetails {
  int? id;
  String? userId;
  String? bio;
  double? price;
  String? price_unit;
  String? status;
  Map<String, dynamic>? availabilitySchedule;
  GeoLocation? location;
  Services? service;

  ProviderDetails({
    this.id,
    this.userId,
    this.bio,
    this.price,
    this.price_unit,
    this.status,
    this.availabilitySchedule,
    this.location,
    this.service,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      id: json['id'],
      userId: json['user_id'],
      bio: json['bio'],
      price: (json['price'] as num).toDouble(),
      price_unit: json['price_unit'] ?? 'hourly',
      status: json['status'] ?? 'active',
      availabilitySchedule: json['availability_schedule'],

      location: json['location'] != null
          ? GeoLocation.fromJson(json['location'])
          : null,

      service: json['services'] != null ? Services.fromJson(json['services']) : null,
    );
  }

  // Method to convert to JSON for sending data back to the database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'price': price,
      'price_unit': price_unit,
      'status': status,
      'availability_schedule': availabilitySchedule,
      'service_id': service?.id,
    };
  }
}
