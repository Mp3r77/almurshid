import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/appointment_bloc.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'المواعيد المتاحة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          const _ScheduleHeader(),
          const SizedBox(height: 20),
          const _CalendarStrip(),
          const SizedBox(height: 20),
          const _TimeGrid(),
        ],
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final monthTitle = DateFormat('MMMM yyyy', 'ar').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthTitle,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today,
                    size: 18, color: colorScheme.onPrimary),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.list,
                    size: 18, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarStrip extends StatelessWidget {
  const _CalendarStrip();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, state.selectedDate);
              final hasDot = index.isOdd;

              return GestureDetector(
                onTap: () =>
                    context.read<AppointmentBloc>().add(SelectDate(date)),
                child: Container(
                  width: 65,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E', 'ar').format(date),
                        style: GoogleFonts.cairo(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date.day.toString(),
                        style: GoogleFonts.cairo(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (hasDot && !isSelected)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _TimeGrid extends StatelessWidget {
  const _TimeGrid();

  final List<String> times = const [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '03:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: times.map((time) {
            final isSelected = state.selectedTime == time;
            return GestureDetector(
              onTap: () =>
                  context.read<AppointmentBloc>().add(SelectTime(time)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  time,
                  style: GoogleFonts.cairo(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
