import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsPage({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل الموعد',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF203A58),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _DoctorSummaryCard(appointment: appointment),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'بيانات المريض',
            child: Column(
              children: [
                _InfoRow('اسم المريض', appointment.patientName ?? '-'),
                _InfoRow(
                    'العمر',
                    appointment.patientAge == null
                        ? '-'
                        : '${appointment.patientAge} عاما'),
                _InfoRow('رقم الهاتف', appointment.patientPhone ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'حالة الدفع',
            child: Column(
              children: [
                _InfoRow('الحالة', appointment.status),
                _InfoRow(
                    'رقم العملية', '#ORD-${appointment.id.padLeft(6, '0')}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'الموقع',
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAF4FF), Color(0xFFF9FCFF)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 64,
                      color: Color(0xFF0F6CAA),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                      'عرض الموقع على الخريطة',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if ((appointment.cancelReason ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'سبب الإلغاء',
              child: Column(
                children: [
                  _InfoRow('السبب', appointment.cancelReason!),
                  if ((appointment.cancelNote ?? '').isNotEmpty)
                    _InfoRow('ملاحظات', appointment.cancelNote!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DoctorSummaryCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _DoctorSummaryCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDEAF7)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              appointment.doctor.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: const Color(0xFFE9F3FF),
                child: const Icon(Icons.person_outline_rounded),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0DA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.status == 'في الانتظار'
                        ? 'قيد الانتظار'
                        : appointment.status,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFFF19A26),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appointment.doctor.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF203A58),
                  ),
                ),
                Text(
                  appointment.doctor.specialty,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF6F7F92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _MetaTile(
                        icon: Icons.calendar_today_outlined,
                        label: 'التاريخ',
                        value: DateFormat('d MMMM yyyy', 'ar')
                            .format(appointment.dateTime),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetaTile(
                        icon: Icons.access_time_rounded,
                        label: 'الوقت',
                        value: DateFormat('hh:mm a', 'ar')
                            .format(appointment.dateTime),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: const Color(0xFF0F6CAA)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: const Color(0xFF6F7F92),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: const Color(0xFF203A58),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF203A58),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                color: const Color(0xFF203A58),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: const Color(0xFF6F7F92),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
