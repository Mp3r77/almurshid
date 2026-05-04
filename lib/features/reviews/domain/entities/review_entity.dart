import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String targetId; // ID of the doctor or center

  const Review({
    required this.id,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.targetId,
  });

  @override
  List<Object?> get props => [id, userName, userImageUrl, rating, comment, createdAt, targetId];
}
