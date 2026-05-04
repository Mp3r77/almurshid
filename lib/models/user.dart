// ============================================================================
// USER MODEL
// ============================================================================
//
// Represents the user data structure used throughout the app.
// This model contains basic user information like name, email, etc.
// ============================================================================

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? imageUrl;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  // Default user for development/demo purposes
  static const User defaultUser = User(
    id: '1',
    fullName: 'أحمد القباطي',
    email: 'ahmed@example.com',
    phone: '775848856',
    imageUrl: 'https://i.pravatar.cc/150?img=11',
  );

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
