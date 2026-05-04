import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class PageChanged extends OnboardingEvent {
  final int index;
  const PageChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class CompleteOnboarding extends OnboardingEvent {
  const CompleteOnboarding();
}
