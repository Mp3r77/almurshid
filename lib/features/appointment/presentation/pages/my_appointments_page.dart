import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../diagnostics/presentation/pages/order_details_page.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';
import 'appointment_details_page.dart';
import 'cancel_appointment_page.dart';
import 'reschedule_appointment_page.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(const LoadAppointments());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<HomeBloc>()
                              .add(const ChangeBottomNavIndex(0)),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'مواعيدي',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF203A58),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final state = context.read<AppointmentBloc>().state;
                            showSearch<void>(
                              context: context,
                              delegate: _AppointmentSearchDelegate([
                                ...state.upcomingAppointments,
                                ...state.previousAppointments,
                                ...state.cancelledAppointments,
                              ]),
                            );
                          },
                          icon: Icon(
                            Icons.search_rounded,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 46,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B3B5A).withOpacity(0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE9F3FF),
                        ),
                        labelColor: const Color(0xFF0E6BA8),
                        unselectedLabelColor: const Color(0xFF8B96A7),
                        labelStyle: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        unselectedLabelStyle: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        tabs: const [
                          Tab(text: 'الحالية'),
                          Tab(text: 'السابقة'),
                          Tab(text: 'الملغاة'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    _AppointmentsList(mode: _AppointmentViewMode.current),
                    _AppointmentsList(mode: _AppointmentViewMode.previous),
                    _AppointmentsList(mode: _AppointmentViewMode.cancelled),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _AppointmentViewMode { current, previous, cancelled }

class _AppointmentsList extends StatelessWidget {
  final _AppointmentViewMode mode;

  const _AppointmentsList({required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state.status == AppointmentStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = switch (mode) {
          _AppointmentViewMode.current => state.upcomingAppointments,
          _AppointmentViewMode.previous => state.previousAppointments,
          _AppointmentViewMode.cancelled => state.cancelledAppointments,
        };

        if (appointments.isEmpty) {
          return Center(
            child: Text(
              _emptyLabel(mode),
              style: GoogleFonts.cairo(
                color: const Color(0xFF7E8B9A),
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 22),
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _AppointmentCard(
              appointment: appointments[index],
              mode: mode,
            );
          },
        );
      },
    );
  }

  String _emptyLabel(_AppointmentViewMode mode) {
    return switch (mode) {
      _AppointmentViewMode.current => 'لا توجد مواعيد حالية',
      _AppointmentViewMode.previous => 'لا توجد مواعيد سابقة',
      _AppointmentViewMode.cancelled => 'لا توجد مواعيد ملغاة',
    };
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final _AppointmentViewMode mode;

  const _AppointmentCard({
    required this.appointment,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF23466B);
    const subtitleColor = Color(0xFF7B8796);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorderColor()),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF244B70).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: appointment.status),
                    const SizedBox(height: 8),
                    Text(
                      appointment.doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.type,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4C6C8D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateText(),
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: subtitleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _secondaryLine(),
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _AppointmentImage(url: appointment.doctor.imageUrl),
            ],
          ),
          const SizedBox(height: 10),
          if (mode == _AppointmentViewMode.cancelled)
            _CancelledReason(appointment: appointment)
          else
            _ActionRow(
              appointment: appointment,
              mode: mode,
            ),
        ],
      ),
    );
  }

  String _dateText() {
    final day = DateFormat('d MMMM yyyy', 'ar').format(appointment.dateTime);
    final time = DateFormat('h:mm a', 'ar').format(appointment.dateTime);
    return '$day - $time';
  }

  String _secondaryLine() {
    final segments = <String>[];
    if (appointment.doctor.specialty.isNotEmpty) {
      segments.add(appointment.doctor.specialty);
    }
    if ((appointment.bookingPeriod ?? '').isNotEmpty) {
      segments.add(appointment.bookingPeriod!);
    }
    return segments.join(' - ');
  }

  Color _cardBorderColor() {
    switch (appointment.status) {
      case 'مؤكد':
        return const Color(0xFFD9F0DF);
      case 'في الانتظار':
        return const Color(0xFFFFE9C7);
      case 'مرفوض':
        return const Color(0xFFFFD8D8);
      default:
        return const Color(0xFFE4EEF8);
    }
  }
}

class _AppointmentImage extends StatelessWidget {
  final String url;

  const _AppointmentImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 74,
        height: 74,
        color: const Color(0xFFF1F5F9),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF90A4B8),
          ),
        ),
      ),
    );
  }
}

class _CancelledReason extends StatelessWidget {
  final AppointmentEntity appointment;

  const _CancelledReason({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final reason = (appointment.cancelReason ?? '').isEmpty
        ? 'لم يتم تحديد سبب الإلغاء'
        : appointment.cancelReason!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.highlight_off_rounded,
            color: Color(0xFFE55B5B),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'سبب الإلغاء: $reason',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE55B5B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final AppointmentEntity appointment;
  final _AppointmentViewMode mode;

  const _ActionRow({
    required this.appointment,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniActionIcon(
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سيتم فتح المحادثة قريباً')),
            );
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            text: 'إلغاء',
            backgroundColor: const Color(0xFFFFF3F3),
            foregroundColor: const Color(0xFFE24848),
            onPressed: mode == _AppointmentViewMode.current
                ? () => _cancelAppointment(context)
                : () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            text: 'تأجيل الحجز',
            backgroundColor: const Color(0xFFF1F4F8),
            foregroundColor: const Color(0xFF5F6E82),
            onPressed: mode == _AppointmentViewMode.current
                ? () => _rescheduleAppointment(context)
                : () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: _ActionButton(
            text: mode == _AppointmentViewMode.previous
                ? 'متابعة الطلب'
                : 'تفاصيل الموعد',
            backgroundColor: const Color(0xFF0F6CAA),
            foregroundColor: Colors.white,
            onPressed: () => _showDetails(context),
          ),
        ),
      ],
    );
  }

  Future<void> _rescheduleAppointment(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RescheduleAppointmentPage(appointment: appointment),
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CancelAppointmentPage(appointment: appointment),
      ),
    );

    if (context.mounted) {
      DefaultTabController.of(context).animateTo(2);
    }
  }

  void _showDetails(BuildContext context) {
    if (appointment.type.contains('أشعة') || appointment.type.contains('مختبر') || appointment.type.contains('كشافة')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailsPage(appointmentId: appointment.id),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsPage(appointment: appointment),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      'مؤكد' => (const Color(0xFFE5F8EA), const Color(0xFF2EA85F), 'مؤكد'),
      'في الانتظار' => (
          const Color(0xFFFFF0DA),
          const Color(0xFFF19A26),
          'قيد الانتظار'
        ),
      'مرفوض' => (const Color(0xFFFFE7E7), const Color(0xFFE45B5B), 'مرفوض'),
      _ => (const Color(0xFFE6F1FF), const Color(0xFF0F6CAA), status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        colors.$3,
        style: GoogleFonts.cairo(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: colors.$2,
        ),
      ),
    );
  }
}

class _MiniActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniActionIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF97A4B3),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AppointmentSearchDelegate extends SearchDelegate<void> {
  final List<AppointmentEntity> appointments;

  _AppointmentSearchDelegate(this.appointments);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildMatches();

  @override
  Widget buildSuggestions(BuildContext context) => _buildMatches();

  Widget _buildMatches() {
    final q = query.trim().toLowerCase();
    final matches = appointments.where((appointment) {
      return appointment.doctor.name.toLowerCase().contains(q) ||
          appointment.doctor.specialty.toLowerCase().contains(q) ||
          appointment.type.toLowerCase().contains(q);
    }).toList();

    if (matches.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج مطابقة',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = matches[index];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFE9F3FF),
            child: Text(
              appointment.doctor.name.isEmpty
                  ? '?'
                  : appointment.doctor.name.substring(0, 1),
              style: GoogleFonts.cairo(
                color: const Color(0xFF0F6CAA),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            appointment.doctor.name,
            style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            appointment.doctor.specialty,
            style: GoogleFonts.cairo(),
          ),
          trailing: Text(
            DateFormat('d/M', 'ar').format(appointment.dateTime),
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
          ),
        );
      },
    );
  }
}
