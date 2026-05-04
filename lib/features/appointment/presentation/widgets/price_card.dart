import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showPricing(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '3,500 ريال',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'رسوم الاستشارة',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.attach_money, color: colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPricing(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return const SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.medical_services_outlined),
                title: Text('رسوم الاستشارة'),
                trailing: Text('3,500 ريال'),
              ),
              ListTile(
                leading: Icon(Icons.receipt_long_outlined),
                title: Text('رسوم الخدمة'),
                trailing: Text('0 ريال'),
              ),
            ],
          ),
        );
      },
    );
  }
}
