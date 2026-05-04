import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/features/appointment/presentation/pages/doctor_details_page.dart';
import 'package:untitled1/features/appointment/presentation/pages/booking_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitled1/core/widgets/full_screen_image_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorCard extends StatelessWidget {
  final dynamic doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => FullScreenImagePage.show(
                  context,
                  doctor.imageUrl ?? 'https://i.pravatar.cc/150?img=32',
                  tag: 'doctor_card_image_${doctor.id ?? doctor.name}',
                ),
                child: Hero(
                  tag: 'doctor_card_image_${doctor.id ?? doctor.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl:
                          doctor.imageUrl ?? 'https://i.pravatar.cc/150?img=32',
                      width: 72,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${doctor.rating ?? 0.0} (${doctor.reviews ?? 0})',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          // معلومات الطبيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name ?? 'اسم الطبيب',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty ?? 'تخصص الطبيب',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey[500],
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.location ?? l10n.location,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     const Icon(
                //       Icons.star,
                //       size: 16,
                //       color: Colors.amber,
                //     ),
                //     const SizedBox(width: 6),
                //     Text(
                //       '${doctor.rating ?? 0.0} (${doctor.reviews ?? 0})',
                //       style: GoogleFonts.cairo(
                //         fontSize: 12,
                //         color: Colors.black87,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // السعر وزر الحجز
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B4C84),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '${doctor.price ?? 0} ${l10n.price}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 88,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(
                          doctor: doctor,
                          initialConsultationType: ConsultationType.inPerson,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B4C84),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.book,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(doctor: doctor),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: Color(0xFF0B4C84),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.details,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: const Color(0xFF0B4C84),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // صورة الطبيب
        ],
      ),
    );
  }
}
