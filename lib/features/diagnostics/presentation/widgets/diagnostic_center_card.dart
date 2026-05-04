import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/diagnostic_entities.dart';
import '../../../../core/widgets/full_screen_image_page.dart';

class DiagnosticCenterCard extends StatelessWidget {
  final DiagnosticCenter center;
  final VoidCallback onTap;
  final VoidCallback onBookTap;

  const DiagnosticCenterCard({
    super.key,
    required this.center,
    required this.onTap,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GestureDetector(
                      onTap: () => FullScreenImagePage.show(
                        context,
                        center.logoUrl ?? center.image,
                        tag: 'center_card_logo_${center.id}',
                      ),
                      child: Hero(
                        tag: 'center_card_logo_${center.id}',
                        child: Container(
                          height: 100,
                          width: 100,
                          color: colorScheme.surfaceContainerHighest,
                          child: CachedNetworkImage(
                            imageUrl: center.logoUrl ?? center.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                center.type == DiagnosticType.radiology
                                    ? Icons.local_hospital
                                    : Icons.biotech,
                                size: 40,
                                color: colorScheme.primary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '${center.rating} • ${center.distance}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: center.isOpen
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        center.isOpen ? 'مفتوح الآن' : 'مغلق حالياً',
                        style: GoogleFonts.cairo(
                          color: center.isOpen ? Colors.green : Colors.red,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      center.name,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: center.services
                          .take(2)
                          .map((s) => _serviceChip(context, s.name))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onBookTap,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month,
                            color: colorScheme.onPrimary),
                        const SizedBox(width: 10),
                        Text(
                          center.type == DiagnosticType.lab
                              ? 'حجز فحص'
                              : 'حجز أشعة',
                          style: GoogleFonts.cairo(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض الملف',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios,
                            size: 14, color: colorScheme.onSurface),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 10,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
