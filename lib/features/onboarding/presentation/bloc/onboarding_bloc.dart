import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';
import 'onboarding_model.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
      : super(const OnboardingState(
          contents: [
            OnboardingContent(
              title: 'احجز موعدًا مع طبيبك في أي وقت ومن أي مكان!',
              subtitle:
                  'اعثر على أطباء موثوق بهم واحجز استشارات ببضع نقرات فقط.',
              imageUrl: 'assets/onboarding_1.png',
            ),
            OnboardingContent(
              title: 'اعثر على أخصائي بسهولة',
              subtitle:
                  'اعثر على أطباء موثوق بهم واحجز استشارات ببضع نقرات فقط.',
              imageUrl: 'assets/onboarding_2.png',
            ),
            OnboardingContent(
              title: 'عرض المواعيد القادمة',
              subtitle:
                  'اعثر على أطباء موثوق بهم واحجز استشارات ببضع نقرات فقط.',
              imageUrl: 'assets/onboarding_3.png',
            ),
          ],
        )) {
    on<PageChanged>(_onPageChanged);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  void _onPageChanged(PageChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  void _onCompleteOnboarding(
      CompleteOnboarding event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(status: OnboardingStatus.completing));
    // Here we would typically save a flag to shared preferences
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
