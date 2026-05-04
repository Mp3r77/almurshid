import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/modern_button.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) async {
        if (state.status == OnboardingStatus.completed) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_first_time', false);

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryBlue,
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: TextButton(
                      onPressed: () => context
                          .read<OnboardingBloc>()
                          .add(const CompleteOnboarding()),
                      child: Text(
                        AppLocalizations.of(context)!.skip,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Expanded(flex: 3, child: SizedBox()),
                      Expanded(
                        flex: 8,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: state.contents.length,
                          onPageChanged: (index) {
                            context
                                .read<OnboardingBloc>()
                                .add(PageChanged(index));
                          },
                          itemBuilder: (context, index) {
                            final content = state.contents[index];
                            return Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(30),
                                child: Image.asset(
                                  content.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(150),
                            topRight: Radius.circular(150),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                state.contents.length,
                                (index) => _buildIndicator(
                                    index, state.currentIndex, isDark),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              _getOnboardingTitle(context, state.currentIndex),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _getOnboardingDesc(context, state.currentIndex),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const Spacer(),
                            ModernButton(
                              icon: Icons.arrow_forward,
                              text: state.currentIndex ==
                                      state.contents.length - 1
                                  ? AppLocalizations.of(context)!.getStarted
                                  : AppLocalizations.of(context)!.next,
                              onPressed: () {
                                if (state.currentIndex ==
                                    state.contents.length - 1) {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(const CompleteOnboarding());
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ModernButtonStyle.gradient,
                              width: double.infinity,
                              height: 55,
                              borderRadius: 18,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getOnboardingTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return l10n.onboardingTitle1;
      case 1:
        return l10n.onboardingTitle2;
      case 2:
        return l10n.onboardingTitle3;
      default:
        return '';
    }
  }

  String _getOnboardingDesc(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return l10n.onboardingDesc1;
      case 1:
        return l10n.onboardingDesc2;
      case 2:
        return l10n.onboardingDesc3;
      default:
        return '';
    }
  }

  Widget _buildIndicator(int index, int currentIndex, bool isDark) {
    final isSelected = index == currentIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isSelected ? 24 : 10,
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryBlue
            : (isDark ? Colors.white24 : Colors.grey[300]),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
