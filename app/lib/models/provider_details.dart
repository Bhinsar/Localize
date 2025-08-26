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
  final int id;
  final String userId;
  final String bio;
  final double hourlyRate;
  final String status;
  final Map<String, dynamic>? availabilitySchedule;
  final GeoLocation? location;
  final Services? service;

  ProviderDetails({
    required this.id,
    required this.userId,
    required this.bio,
    required this.hourlyRate,
    required this.status,
    this.availabilitySchedule,
    this.location,
    this.service,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      id: json['id'],
      userId: json['user_id'],
      bio: json['bio'],
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      status: json['status'] ?? 'active',
      availabilitySchedule: json['availability_schedule'],
      
      location: json['location'] != null
          ? GeoLocation.fromJson(json['location'])
          : null,
          
      service: json['services'] != null
          ? Services.fromJson(json['services'])
          : null,
    );
  }

  // Method to convert to JSON for sending data back to the database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'hourly_rate': hourlyRate,
      'status': status,
      'availability_schedule': availabilitySchedule,
      // For updates, you would typically only send the service_id
      'service_id': service?.id, 
      // Location would need to be converted to a format PostGIS understands,
      // e.g., 'SRID=4326;POINT(longitude latitude)'
      // This part depends on your backend/API requirements.
    };
  }
}