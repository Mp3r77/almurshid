import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/profile_bloc.dart';
import 'profile_strings.dart';

class SecurityPrivacyPage extends StatelessWidget {
  const SecurityPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = ProfileStrings.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t.securityPrivacyTitle,
          style: GoogleFonts.cairo(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SectionCard(
                title: t.passwordSection,
                child: Column(
                  children: [
                    _ArrowTile(
                      icon: Icons.lock_outline_rounded,
                      title: t.changePassword,
                      onTap: () => _showSnack(context, t.passwordServerLater),
                    ),
                    const SizedBox(height: 10),
                    _ArrowTile(
                      icon: Icons.key_outlined,
                      title: t.passkeys,
                      onTap: () => _showSnack(context, t.passkeysSoon),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: t.biometricSection,
                child: Column(
                  children: [
                    _SwitchTile(
                      icon: Icons.fingerprint_rounded,
                      title: t.biometricLogin,
                      value: state.biometricLogin,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleBiometricLogin(value));
                      },
                    ),
                    const SizedBox(height: 10),
                    _SwitchTile(
                      icon: Icons.face_retouching_natural_outlined,
                      title: t.faceRecognition,
                      value: state.faceRecognition,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleFaceRecognition(value));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: t.privacySection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.whoCanSeeMedicalFile,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF223546),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PrivacyOption(
                      title: t.privacyDoctorsOnly,
                      value: 'doctors_only',
                      groupValue: state.privacyMode,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<ProfileBloc>()
                              .add(ChangePrivacyMode(value));
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _PrivacyOption(
                      title: t.privacyAllStaff,
                      value: 'all_staff',
                      groupValue: state.privacyMode,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<ProfileBloc>()
                              .add(ChangePrivacyMode(value));
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _SwitchTile(
                      icon: Icons.verified_user_outlined,
                      title: t.twoFactor,
                      value: state.twoFactorVerification,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleTwoFactorVerification(value));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF223546),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ArrowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ArrowTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2EBF3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left_rounded, color: Color(0xFF93A3B4)),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF223546),
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: const Color(0xFF0A5C97), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBF3)),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0A5C97),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF223546),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: const Color(0xFF0A5C97), size: 20),
        ],
      ),
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PrivacyOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBF3)),
      ),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: const Color(0xFF0A5C97),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF223546),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
