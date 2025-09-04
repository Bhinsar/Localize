import 'package:app/models/services.dart';

class GeoLocation {
  double latitude;
  double longitude;
  String? address; 

  GeoLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as List;
    return GeoLocation(
      longitude: coordinates[0].toDouble(),
      latitude: coordinates[1].toDouble(),
      address: json['address'], 
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
      'address': address,
    };
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
  GeoLocation location; 
  Services? service;

  ProviderDetails({
    this.id,
    this.userId,
    this.bio,
    this.price,
    this.price_unit,
    this.status,
    this.availabilitySchedule,
    GeoLocation? location, 
    this.service,
  }) : this.location = location ?? GeoLocation(latitude: 0.0, longitude: 0.0); 

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      id: json['id'],
      userId: json['user_id'],
      bio: json['bio'],
      price: (json['price'] as num?)?.toDouble(),
      price_unit: json['price_unit'] ?? 'hourly',
      status: json['status'] ?? 'active',
      availabilitySchedule: json['availability_schedule'],
      location: json['location'] != null
          ? GeoLocation.fromJson(json['location'])
          : null, // It will be handled by the constructor's initializer
      service: json['services'] != null ? Services.fromJson(json['services']) : null,
    );
  }

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
      'location': location.toJson(),
    };
  }
}