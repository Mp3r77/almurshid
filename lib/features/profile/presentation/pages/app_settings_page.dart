import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/locale/locale_cubit.dart';
import '../bloc/profile_bloc.dart';
import 'profile_strings.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

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
          t.settingsAlertsTitle,
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
              _SettingsCard(
                title: t.appLanguage,
                child: Row(
                  children: [
                    Expanded(
                      child: _LanguageChip(
                        title: 'English',
                        selected: state.language == 'English',
                        onTap: () {
                          context
                              .read<ProfileBloc>()
                              .add(const ChangeAppLanguage('English'));
                          context.read<LocaleCubit>().setEnglish();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LanguageChip(
                        title: 'العربية',
                        selected: state.language == 'العربية',
                        onTap: () {
                          context
                              .read<ProfileBloc>()
                              .add(const ChangeAppLanguage('العربية'));
                          context.read<LocaleCubit>().setArabic();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                title: t.appSettings,
                child: Column(
                  children: [
                    _ToggleRow(
                      title: t.bookingAlerts,
                      subtitle: t.bookingAlertsSub,
                      value: state.bookingReminders,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleBookingReminders(value));
                      },
                    ),
                    _ToggleRow(
                      title: t.messageAlerts,
                      subtitle: t.messageAlertsSub,
                      value: state.messageAlerts,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleMessageAlerts(value));
                      },
                    ),
                    _ToggleRow(
                      title: t.medicalOffers,
                      subtitle: t.medicalOffersSub,
                      value: state.medicalOffers,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleMedicalOffers(value));
                      },
                    ),
                    _ToggleRow(
                      title: t.appointmentStatusChange,
                      subtitle: t.appointmentStatusChangeSub,
                      value: state.rescheduleAlerts,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleRescheduleAlerts(value));
                      },
                    ),
                    _ToggleRow(
                      title: t.smartDiagnosisResults,
                      subtitle: t.smartDiagnosisResultsSub,
                      value: state.smartDiagnosisAlerts,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ToggleSmartDiagnosisAlerts(value));
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
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

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

class _LanguageChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0A5C97) : const Color(0xFFF8FBFE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF0A5C97) : const Color(0xFFDCE8F3),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : const Color(0xFF294051),
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF223546),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: const Color(0xFF8A99A8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
