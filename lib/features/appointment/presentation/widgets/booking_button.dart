import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/modern_button.dart';
import '../bloc/appointment_bloc.dart';
import '../pages/review_pay_page.dart';

class BookingButton extends StatelessWidget {
  const BookingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: Theme.of(context).colorScheme.surface,
      child: ModernButton(
        text: 'تأكيد وحجز الموعد',
        onPressed: () {
          final state = context.read<AppointmentBloc>().state;
          if (state.selectedTime.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('اختر الوقت المناسب أولاً')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReviewPayPage()),
          );
        },
        style: ModernButtonStyle.gradient,
        width: double.infinity,
        height: 60,
        borderRadius: 20,
        icon: Icons.arrow_back_ios,
        elevation: 5,
      ),
    );
  }
}
