import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointment/presentation/pages/my_appointments_page.dart';
import 'home/presentation/bloc/home_bloc.dart';
import 'home/presentation/pages/home_screen.dart';
import 'home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'messages/presentation/pages/messages_screen.dart';
import 'profile/presentation/pages/profile_page.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentIndex = state.selectedIndex;

        return PopScope(
          canPop: currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (currentIndex > 0) {
              context.read<HomeBloc>().add(const ChangeBottomNavIndex(0));
            }
          },
          child: Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: const [
                HomeScreen(),
                MyAppointmentsPage(),
                MessagesScreen(),
                ProfilePage(),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          ),
        );
      },
    );
  }
}
