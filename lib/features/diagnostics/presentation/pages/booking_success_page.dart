import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/diagnostic_entities.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/diagnostics_bloc.dart';
import '../bloc/diagnostics_state.dart';
import 'order_tracking_page.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
      builder: (context, state) {
        final booking = state.currentBooking;
        if (booking == null) {
          return Scaffold(body: Center(child: Text(l10n.noBookingFound)));
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment:
                        Directionality.of(context) == ui.TextDirection.rtl
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Icon
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.hourglass_empty,
                          size: 80, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.thankYou,
                    style: GoogleFonts.cairo(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.verificationWait,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, color: Colors.blue, size: 8),
                        const SizedBox(width: 8),
                        Text(l10n.pendingConfirmation,
                            style: GoogleFonts.cairo(
                                color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Appointment Details Card
                  Align(
                    alignment:
                        Directionality.of(context) == ui.TextDirection.rtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Text(l10n.bookingDetails,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                booking.center.name,
                                textAlign: TextAlign.end,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                booking.center.type == DiagnosticType.radiology
                                    ? 'باقة الفحص الشامل'
                                    : 'باقة فحص المختبر',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              _detailRow(
                                  l10n.bookingDate,
                                  DateFormat(
                                          'dd MMMM yyyy',
                                          Localizations.localeOf(context)
                                              .languageCode)
                                      .format(booking.appointmentDate)),
                              _detailRow(l10n.appointmentTime,
                                  booking.appointmentTime),
                              _detailRow(l10n.referenceNumber, booking.id),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.biotech_outlined,
                              color: Colors.blue, size: 30),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderTrackingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00558A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.trackOrder,
                          style:
                              GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(const ChangeBottomNavIndex(1));
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00558A)),
                        foregroundColor: const Color(0xFF00558A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.viewAppointments,
                          style:
                              GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: Text(l10n.helpSupportText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: Colors.grey, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value,
              style:
                  GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.blue)),
        ],
      ),
    );
  }
}
