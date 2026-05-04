import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الطوارئ',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emergency, size: 80, color: colorScheme.error),
                      const SizedBox(height: 20),
                      Text(
                        'خدمات الطوارئ',
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'يمكنك طلب المساعدة العاجلة أو مشاركة موقعك مع فريق الدعم الطبي.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('تم إرسال تنبيه طوارئ مع الموقع الحالي')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.sos),
              label: const Text('إرسال نداء استغاثة'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('أرقام الطوارئ'),
                    content:
                        Text('الإسعاف: 997\nالشرطة: 999\nالدفاع المدني: 998'),
                  ),
                );
              },
              icon: const Icon(Icons.call_outlined),
              label: const Text('عرض أرقام الطوارئ'),
            ),
          ],
        ),
      ),
    );
  }
}
