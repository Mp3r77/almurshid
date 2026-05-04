import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../main_shell.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _indicatorFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
    _textSlideAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _indicatorFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) async {
          if (state is SplashCompleted) {
            final prefs = await SharedPreferences.getInstance();
            final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
            final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

            if (context.mounted) {
              if (isFirstTime) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const OnboardingPage()),
                );
              } else if (!isLoggedIn) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                );
              }
            }
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.secondaryBlue,
                  AppTheme.primaryBlue.withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: -80,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _logoSlideAnimation,
                              child: FadeTransition(
                                opacity: _logoFadeAnimation,
                                child: ScaleTransition(
                                  scale: _logoScaleAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Hero(
                                        tag: 'app_logo',
                                        child: Image.asset(
                                          'assets/logo.png',
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _textSlideAnimation.value),
                              child: FadeTransition(
                                opacity: _textFadeAnimation,
                                child: Column(
                                  children: [
                                    Text(
                                      l10n.smartMedicalGuide,
                                      style: GoogleFonts.cairo(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.completeMedicalGuide,
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.95),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const Spacer(flex: 3),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _indicatorFadeAnimation,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.loading,
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
