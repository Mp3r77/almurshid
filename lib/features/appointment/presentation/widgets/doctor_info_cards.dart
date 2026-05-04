import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorInfoCards extends StatelessWidget {
  const DoctorInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: InfoCard(
              icon: Icons.work_outline,
              label: 'الخبرة',
              value: 'أكثر من 5 سنوات',
              iconColor: Color(0xFF2196F3),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: InfoCard(
              icon: Icons.star_border,
              label: 'التقييم',
              value: '4.8 (120)',
              iconColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showDetails(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final message = label == 'الخبرة'
        ? 'الطبيبة لديها خبرة سريرية ممتدة في الاستشارات والمتابعات الدورية.'
        : 'متوسط تقييم المرضى مرتفع بناءً على عدد كبير من الزيارات السابقة.';

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Text(message, style: GoogleFonts.cairo(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
