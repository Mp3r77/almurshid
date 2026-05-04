import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorHeader extends StatelessWidget {
  const DoctorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: Colors.blue[400], size: 20),
            const SizedBox(width: 5),
            Text(
              'د. لمياء الأهدل',
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Text(
          'بكالوريوس الطب والجراحة، دبلوم الأمراض الباطنية، خبرة واسعة في تشخيص وعلاج الحالات المزمنة.',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
