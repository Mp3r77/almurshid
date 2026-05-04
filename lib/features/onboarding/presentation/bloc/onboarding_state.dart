import 'package:equatable/equatable.dart';
import 'onboarding_model.dart';

enum OnboardingStatus { initial, completing, completed }

class OnboardingState extends Equatable {
  final List<OnboardingContent> contents;
  final int currentIndex;
  final OnboardingStatus status;

  const OnboardingState({
    this.contents = const [],
    this.currentIndex = 0,
    this.status = OnboardingStatus.initial,
  });

  OnboardingState copyWith({
    List<OnboardingContent>? contents,
    int? currentIndex,
    OnboardingStatus? status,
  }) {
    return OnboardingState(
      contents: contents ?? this.contents,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [contents, currentIndex, status];
}
