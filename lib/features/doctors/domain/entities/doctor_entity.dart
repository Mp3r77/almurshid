// ============================================================================
// DOCTOR ENTITY - Domain Layer
// ============================================================================
//
// PURPOSE:
// - Pure Dart class with no external dependencies
// - Core business object representing a Doctor
// - Used throughout the application (domain & presentation)
//
// RULES:
// 1. Entities are immutable (final fields)
// 2. No business logic in entities (keep them thin)
// 3. No JSON/parsing code
// 4. Use Equatable for value equality
// ============================================================================

import 'package:equatable/equatable.dart';

/// Domain entity representing a Doctor
///
/// This is a pure Dart class used across all layers:
/// - Domain: Business rules and use cases
/// - Presentation: UI widgets and BLoC states
///
/// The entity is converted to/from DoctorModel in the data layer
class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final String bio;
  final double rating;
  final int reviews;
  final String imageUrl;
  final int price;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.bio,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.price,
  });

  /// Copy with new values
  ///
  /// Creates a new instance with updated fields
  /// while preserving unchanged fields
  DoctorEntity copyWith({
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
    return DoctorEntity(
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

  /// Get formatted price string
  String get formattedPrice => '$price ر.ي';

  /// Get reviews count with label
  String get reviewsText => '$reviews تقييم';

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        location,
        bio,
        rating,
        reviews,
        imageUrl,
        price,
      ];
}
