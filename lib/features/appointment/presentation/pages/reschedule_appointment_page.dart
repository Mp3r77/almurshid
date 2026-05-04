import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class RescheduleAppointmentPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const RescheduleAppointmentPage({
    super.key,
    required this.appointment,
  });

  @override
  State<RescheduleAppointmentPage> createState() =>
      _RescheduleAppointmentPageState();
}

class _RescheduleAppointmentPageState extends State<RescheduleAppointmentPage> {
  static const _morningTimes = ['09:00 AM', '09:30 AM', '10:00 AM', '11:30 AM'];
  static const _eveningTimes = ['04:00 PM', '04:30 PM', '05:00 PM', '06:00 PM'];

  @override
  void initState() {
    super.initState();
    context
        .read<AppointmentBloc>()
        .add(PrepareRescheduleDraft(widget.appointment.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == AppointmentActionStatus.success &&
            (state.actionMessage ?? '').isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionMessage!)),
          );
          context
              .read<AppointmentBloc>()
              .add(const ResetAppointmentActionState());
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'تأجيل الموعد',
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
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _CurrentAppointmentCard(appointment: widget.appointment),
                const SizedBox(height: 14),
                Text(
                  'اختر التاريخ الجديد',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF203A58),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: CalendarDatePicker(
                    initialDate: state.rescheduleDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 120)),
                    onDateChanged: (date) {
                      context
                          .read<AppointmentBloc>()
                          .add(UpdateRescheduleDate(date));
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _TimeSection(
                  title: 'الفترة الصباحية',
                  times: _morningTimes,
                  selectedTime: state.rescheduleTime,
                ),
                const SizedBox(height: 14),
                _TimeSection(
                  title: 'الفترة المسائية',
                  times: _eveningTimes,
                  selectedTime: state.rescheduleTime,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        state.actionStatus == AppointmentActionStatus.submitting
                            ? null
                            : () {
                                context.read<AppointmentBloc>().add(
                                    SubmitRescheduleAppointment(
                                        widget.appointment.id));
                              },
                    child: Text(
                      state.actionStatus == AppointmentActionStatus.submitting
                          ? 'جارٍ الإرسال...'
                          : 'طلب تأجيل الموعد',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'رجوع',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CurrentAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _CurrentAppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              appointment.doctor.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFFE9F3FF),
                child: const Icon(Icons.person_outline),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الموعد الحالي',
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF6F7F92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.doctor.name,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF0F6CAA),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${DateFormat('d MMMM', 'ar').format(appointment.dateTime)} - ${DateFormat('hh:mm a', 'ar').format(appointment.dateTime)}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF7C8796),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSection extends StatelessWidget {
  final String title;
  final List<String> times;
  final String selectedTime;

  const _TimeSection({
    required this.title,
    required this.times,
    required this.selectedTime,
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
              color: const Color(0xFF203A58),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times.map((time) {
              final selected = time == selectedTime;
              return ChoiceChip(
                label: Text(
                  DateFormat('hh:mm a', 'en').parse(time).hour >= 12
                      ? DateFormat('hh:mm a', 'ar').format(
                          DateFormat('hh:mm a', 'en').parse(time),
                        )
                      : DateFormat('hh:mm a', 'ar').format(
                          DateFormat('hh:mm a', 'en').parse(time),
                        ),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : const Color(0xFF5F6E82),
                  ),
                ),
                selected: selected,
                onSelected: (_) {
                  context
                      .read<AppointmentBloc>()
                      .add(UpdateRescheduleTime(time));
                },
                selectedColor: const Color(0xFF0F6CAA),
                backgroundColor: const Color(0xFFF4F6F9),
                side: const BorderSide(color: Color(0xFFD7DFE8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
