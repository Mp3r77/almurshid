import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_event.dart';
import 'review_state.dart';
import '../../domain/entities/review_entity.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(const ReviewState()) {
    on<LoadReviews>(_onLoadReviews);
    on<SubmitReview>(_onSubmitReview);
  }

  void _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    
    // Mock loading reviews
    await Future.delayed(const Duration(seconds: 1));
    
    final mockReviews = [
      Review(
        id: '1',
        userName: 'أحمد محمود',
        rating: 5.0,
        comment: 'خدمة ممتازة واحترافية عالية في التعامل.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        targetId: event.targetId,
      ),
      Review(
        id: '2',
        userName: 'سارة خالد',
        rating: 4.0,
        comment: 'التجربة كانت جيدة ولكن كان هناك بعض التأخير في الموعد.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        targetId: event.targetId,
      ),
    ];
    
    emit(state.copyWith(
      status: ReviewStatus.success,
      reviews: mockReviews,
    ));
  }

  void _onSubmitReview(SubmitReview event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(status: ReviewStatus.submitting));
    
    // Mock submitting review
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'مستخدم جديد', // In a real app, get from AuthBloc
      rating: event.rating,
      comment: event.comment,
      createdAt: DateTime.now(),
      targetId: event.targetId,
    );
    
    final updatedReviews = List<Review>.from(state.reviews)..insert(0, newReview);
    
    emit(state.copyWith(
      status: ReviewStatus.submitSuccess,
      reviews: updatedReviews,
    ));
  }
}
