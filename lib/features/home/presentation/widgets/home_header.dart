import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/utils/user_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/theme/theme_bloc.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/custom_icon_button.dart';
import '../../../../core/widgets/user_info.dart';
import '../../../diagnosis/presentation/pages/smart_diagnosis_screen.dart';
import '../../../doctors/presentation/pages/doctors_list_page.dart';
import '../../../notifications/presentation/pages/notification_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        AppHeader(
          leading: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return UserInfo(
                imageUrl:
                    state.user.imageUrl ?? 'https://i.pravatar.cc/150?img=11',
                greeting: l10n.greeting,
                userName: state.user.fullName,
                textColor: Colors.white,
              );
            },
          ),
          trailing: Row(
            children: [
              CustomIconButton(
                icon: Icons.menu,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              const SizedBox(width: 10),
              BlocBuilder<ThemeBloc, ThemeMode>(
                builder: (context, themeMode) {
                  return CustomIconButton(
                    icon: themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    onPressed: () => context.read<ThemeBloc>().toggleTheme(),
                  );
                },
              ),
              const SizedBox(width: 10),
              CustomIconButton(
                icon: Icons.notifications_none,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                hasBadge: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppSearchBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          leadingIcon: GestureDetector(
            onTap: () => _showQuickActions(context),
            child: Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onChanged: (value) {
            final query = value.trim();
            if (query.isEmpty) return;
            if (query.contains('تشخيص')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SmartDiagnosisScreen(),
                ),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorsListPage(initialQuery: query),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_search_outlined),
                title: Text(l10n.viewDoctors),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorsListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.psychology_outlined),
                title: Text(l10n.openSmartDiagnosis),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SmartDiagnosisScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
