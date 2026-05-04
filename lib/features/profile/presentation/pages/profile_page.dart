import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/user_bloc.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'app_settings_page.dart';
import 'help_support_page.dart';
import 'personal_info_page.dart';
import 'profile_strings.dart';
import 'security_privacy_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const LoadProfilePreferences()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = ProfileStrings.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t.profileTitle,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              final user = userState.user;
              final imageProvider = profileImageProvider(
                profileState.localProfileImage,
                user.imageUrl,
              );

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundImage: imageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A5C97),
                                  borderRadius: BorderRadius.circular(14),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1D2B38),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: const Color(0xFF8293A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _MenuCard(
                    icon: Icons.person_outline_rounded,
                    title: t.personalInfoTitle,
                    subtitle: t.editBasicInfo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: const PersonalInfoPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.lock_outline_rounded,
                    title: t.securityPrivacyTitle,
                    subtitle: t.managePasswordPrivacy,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: const SecurityPrivacyPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.settings_outlined,
                    title: t.settingsAlertsTitle,
                    subtitle: t.appLanguageAlerts,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: const AppSettingsPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.help_outline_rounded,
                    title: t.helpCenterTitle,
                    subtitle: t.faqAndSupport,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: const HelpSupportPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        t.logout,
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2B2B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF2B2B),
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'تسجيل الخروج',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D2B38),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج؟\nستحتاج لإعادة إدخال بياناتك للدخول مرة أخرى',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: const Color(0xFF8293A5),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8293A5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('is_logged_in', false);

                        // Reset Home index to 0 for next time
                        if (context.mounted) {
                          context
                              .read<HomeBloc>()
                              .add(const ChangeBottomNavIndex(0));
                        }

                        // Close the app
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else {
                          exit(0);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2B2B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'تسجيل الخروج',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0A5C97), size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1D2B38),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: const Color(0xFF8B9BAA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward_ios
                  : Icons.chevron_right_rounded,
              color: const Color(0xFF9AAABA),
            ),
          ],
        ),
      ),
    );
  }
}

ImageProvider<Object> profileImageProvider(
  String? localImage,
  String? remoteImage,
) {
  if (localImage != null && localImage.isNotEmpty) {
    return FileImage(File(localImage));
  }

  if (remoteImage != null && remoteImage.isNotEmpty) {
    if (remoteImage.startsWith('http')) {
      return NetworkImage(remoteImage);
    }
    return FileImage(File(remoteImage));
  }

  return const NetworkImage('https://i.pravatar.cc/150?img=11');
}
