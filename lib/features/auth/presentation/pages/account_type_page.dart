import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_strings.dart';
import 'register_patient_page.dart';
import 'register_provider_page.dart';

class AccountTypePage extends StatelessWidget {
  const AccountTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AuthStrings.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.accountTypeTitle,
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward
                : Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              t.createNewAccount,
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(
              t.welcomePlatform,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.chooseTrack,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _AccountTypeCard(
              title: t.patientOption,
              subtitle: t.patientOptionSubtitle,
              icon: Icons.person_outline,
              buttonText: t.startAsPatient,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPatientPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _AccountTypeCard(
              title: t.providerOption,
              subtitle: t.providerOptionSubtitle,
              icon: Icons.medical_services_outlined,
              buttonText: t.joinAsProvider,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterProviderPage(isLab: false),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _AccountTypeCard(
              title: t.labOption,
              subtitle: t.labOptionSubtitle,
              icon: Icons.biotech_outlined,
              buttonText: t.joinAsLab,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterProviderPage(isLab: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.alreadyHaveAccount,
                  style: GoogleFonts.cairo(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    t.loginButton,
                    style: GoogleFonts.cairo(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonText;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                radius: 24,
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
