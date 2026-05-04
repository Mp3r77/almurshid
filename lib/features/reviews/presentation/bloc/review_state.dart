import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';

enum ReviewStatus { initial, loading, success, failure, submitting, submitSuccess }

class ReviewState extends Equatable {
  final List<Review> reviews;
  final ReviewStatus status;
  final String? errorMessage;

  const ReviewState({
    this.reviews = const [],
    this.status = ReviewStatus.initial,
    this.errorMessage,
  });

  ReviewState copyWith({
    List<Review>? reviews,
    ReviewStatus? status,
    String? errorMessage,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [reviews, status, errorMessage];
}
