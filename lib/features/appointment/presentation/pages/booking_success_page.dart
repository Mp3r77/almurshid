import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:almurshid/features/appointment/presentation/bloc/appointment_bloc.dart';

import '../../../home/presentation/bloc/home_bloc.dart';

class BookingSuccessPage extends StatelessWidget {
  final dynamic doctor;
  final String? bookingType;

  const BookingSuccessPage({super.key, this.doctor, this.bookingType});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurface),
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                  ),
                  Text(
                    'تأكيد الحجز',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 30),
              Text(
                'تم الحجز بنجاح',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'تم تأكيد الدفع وإتمام موعدك مع ${doctor?.name ?? "الجهة المختارة"}.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              _AppointmentDetailsBox(bookingType: bookingType),
              const SizedBox(height: 20),
              const _NotificationNote(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().add(const ChangeBottomNavIndex(1));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'عرض مواعيدك',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Text(
                  'العودة للرئيسية',
                  style: GoogleFonts.cairo(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentDetailsBox extends StatelessWidget {
  final String? bookingType;

  const _AppointmentDetailsBox({this.bookingType});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appointmentState = context.read<AppointmentBloc>().state;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            'تفاصيل الموعد',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _detailRow(context, 'رقم الحجز', '#12345'),
          _detailRow(
            context,
            'التاريخ والوقت',
            '${DateFormat('d MMMM', 'ar').format(appointmentState.selectedDate)}، ${appointmentState.selectedTime}',
          ),
          _detailRow(context, 'نوع الجلسة', bookingType ?? 'استشارة فيديو'),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationNote extends StatelessWidget {
  const _NotificationNote();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorScheme.primary.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              'تم إرسال إشعار للمستخدم بإتمام عملية الحجز بعد تأكيد الدفع.',
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.notifications_active_outlined,
              color: colorScheme.primary, size: 20),
        ],
      ),
    );
  }
}
