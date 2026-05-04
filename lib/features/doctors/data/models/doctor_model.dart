// ============================================================================
// DOCTOR MODEL - Data Transfer Object
// ============================================================================
//
// PURPOSE:
// - JSON serialization/deserialization
// - Data layer representation of DoctorEntity
// - Contains parsing logic for API responses
//
// MAPPING:
// JSON → DoctorModel → DoctorEntity (via toEntity())
//
// RULES:
// 1. Models belong to data layer only
// 2. Convert to entities before passing to domain
// 3. Handle all edge cases in parsing
// ============================================================================

import '../../domain/entities/doctor_entity.dart';

/// Data model for Doctor with JSON serialization
///
/// This class handles:
/// - Parsing JSON from API
/// - Converting to domain entity
/// - Creating from entity (for testing)
class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.location,
    required super.bio,
    required super.rating,
    required super.reviews,
    required super.imageUrl,
    required super.price,
  });

  /// Create DoctorModel from JSON map
  ///
  /// Throws [FormatException] if required fields are missing
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    _validateJson(json);

    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      reviews: _parseInt(json['reviews']),
      imageUrl: json['image_url']?.toString() ??
          json['imageUrl']?.toString() ??
          json['avatar']?.toString() ??
          '',
      price: _parseInt(json['price']),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'location': location,
      'bio': bio,
      'rating': rating,
      'reviews': reviews,
      'image_url': imageUrl,
      'price': price,
    };
  }

  /// Convert to domain entity
  DoctorEntity toEntity() {
    return DoctorEntity(
      id: id,
      name: name,
      specialty: specialty,
      location: location,
      bio: bio,
      rating: rating,
      reviews: reviews,
      imageUrl: imageUrl,
      price: price,
    );
  }

  /// Create from domain entity
  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      location: entity.location,
      bio: entity.bio,
      rating: entity.rating,
      reviews: entity.reviews,
      imageUrl: entity.imageUrl,
      price: entity.price,
    );
  }

  /// Copy with new values
  @override
  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? location,
    String? bio,
    double? rating,
    int? reviews,
    String? imageUrl,
    int? price,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  /// Validate required fields
  static void _validateJson(Map<String, dynamic> json) {
    final requiredFields = ['id', 'name', 'specialty'];
    final missingFields =
        requiredFields.where((field) => json[field] == null).toList();

    if (missingFields.isNotEmpty) {
      throw FormatException(
        'DoctorModel: Missing required fields: ${missingFields.join(', ')}',
      );
    }
  }

  /// Parse double with fallback
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Parse int with fallback
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [id, name, specialty, location, bio, rating, reviews, imageUrl, price];
}
