import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/profile_bloc.dart';
import 'profile_strings.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = ProfileStrings.of(context);
    final faqItems = [
      (question: t.faqCancelQuestion, answer: t.faqCancelAnswer),
      (question: t.faqPaymentQuestion, answer: t.faqPaymentAnswer),
      (question: t.faqEditProfileQuestion, answer: t.faqEditProfileAnswer),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t.helpCenterTitle,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.faqTitle,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF223546),
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < faqItems.length; i++) ...[
                      _FaqTile(
                        question: faqItems[i].question,
                        answer: faqItems[i].answer,
                        expanded: state.expandedFaqIndex == i,
                        onTap: () {
                          context.read<ProfileBloc>().add(ToggleFaqItem(i));
                        },
                      ),
                      if (i != faqItems.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.contactUs,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF223546),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ContactCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: t.liveChat,
                      subtitle: t.liveChatSub,
                      highlighted: true,
                      onTap: () => _showSnack(context, t.liveChatSoon),
                    ),
                    const SizedBox(height: 10),
                    _ContactCard(
                      icon: Icons.call_outlined,
                      title: t.phoneCall,
                      subtitle: t.phoneCallSub,
                      onTap: () => _showSnack(context, t.supportPhoneValue),
                    ),
                    const SizedBox(height: 10),
                    _ContactCard(
                      icon: Icons.email_outlined,
                      title: t.supportEmail,
                      subtitle: t.supportEmailSub,
                      onTap: () => _showSnack(context, t.supportEmailValue),
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

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2EBF3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF8EA0B0),
                ),
                const Spacer(),
                Expanded(
                  child: Text(
                    question,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF223546),
                    ),
                  ),
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 10),
              Text(
                answer,
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: const Color(0xFF718191),
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool highlighted;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color:
              highlighted ? const Color(0xFF0A5C97) : const Color(0xFFF8FBFE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                highlighted ? const Color(0xFF0A5C97) : const Color(0xFFE2EBF3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left_rounded,
              color: highlighted ? Colors.white70 : const Color(0xFF8EA0B0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color:
                          highlighted ? Colors.white : const Color(0xFF223546),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: highlighted
                          ? Colors.white70
                          : const Color(0xFF8A99A8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: highlighted ? Colors.white : const Color(0xFF0A5C97),
            ),
          ],
        ),
      ),
    );
  }
}
