import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class CancelAppointmentPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const CancelAppointmentPage({
    super.key,
    required this.appointment,
  });

  @override
  State<CancelAppointmentPage> createState() => _CancelAppointmentPageState();
}

class _CancelAppointmentPageState extends State<CancelAppointmentPage> {
  final _noteController = TextEditingController();
  static const _reasons = [
    'السعر مرتفع',
    'وجدت موعدا أقرب',
    'ظروف شخصية',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(const ResetAppointmentActionState());
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
            'إلغاء الطلب',
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
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFFFF1F1),
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF202B3A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'يرجى العلم أنه قد يتم فرض رسوم إدارية في حال الإلغاء المتأخر حسب سياسة المركز الطبي المعتمدة.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF818B98),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'يرجى اختيار سبب الإلغاء:',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF203A58),
                  ),
                ),
                const SizedBox(height: 12),
                ..._reasons.map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CancellationReasonTile(
                      reason: reason,
                      selected: state.cancellationReason == reason,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  onChanged: (value) {
                    context
                        .read<AppointmentBloc>()
                        .add(UpdateCancellationNote(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'أدخل ملاحظة إضافية اختيارية',
                    hintStyle: GoogleFonts.cairo(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        state.actionStatus == AppointmentActionStatus.submitting
                            ? null
                            : () {
                                if (state.cancellationReason.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('اختر سبب الإلغاء أولاً'),
                                    ),
                                  );
                                  return;
                                }

                                context.read<AppointmentBloc>().add(
                                      CancelBookedAppointment(
                                        appointmentId: widget.appointment.id,
                                        reason: state.cancellationReason,
                                        note: state.cancellationNote.trim(),
                                      ),
                                    );
                              },
                    child: Text(
                      state.actionStatus == AppointmentActionStatus.submitting
                          ? 'جارٍ تأكيد الإلغاء...'
                          : 'تأكيد الإلغاء',
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

class _CancellationReasonTile extends StatelessWidget {
  final String reason;
  final bool selected;

  const _CancellationReasonTile({
    required this.reason,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AppointmentBloc>().add(UpdateCancellationReason(reason));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF5FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF0F6CAA) : const Color(0xFFD6DEE7),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color:
                  selected ? const Color(0xFF2A79C1) : const Color(0xFF9DA7B5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reason,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF203A58),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
