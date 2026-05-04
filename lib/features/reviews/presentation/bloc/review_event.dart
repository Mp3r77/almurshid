import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReview extends ReviewEvent {
  final String targetId;
  final double rating;
  final String comment;
  final String targetName;
  final String? targetImageUrl;
  final String? targetSubtitle;

  const SubmitReview({
    required this.targetId,
    required this.rating,
    required this.comment,
    required this.targetName,
    this.targetImageUrl,
    this.targetSubtitle,
  });

  @override
  List<Object?> get props =>
      [targetId, rating, comment, targetName, targetImageUrl, targetSubtitle];
}

class LoadReviews extends ReviewEvent {
  final String targetId;

  const LoadReviews(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
