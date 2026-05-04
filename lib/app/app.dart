import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/locale/locale_cubit.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_bloc.dart';
import '../core/utils/user_bloc.dart';
import '../features/appointment/presentation/bloc/appointment_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/diagnosis/presentation/bloc/diagnosis_bloc.dart';
import '../features/doctors/presentation/bloc/doctors_bloc.dart';
import '../features/doctors/presentation/bloc/doctors_event.dart';
import '../features/diagnostics/presentation/bloc/diagnostics_bloc.dart';
import '../features/reviews/presentation/bloc/review_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/messages/presentation/bloc/messages_bloc.dart';
import '../features/messages/presentation/bloc/messages_event.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;

class AlMurshidApp extends StatelessWidget {
  const AlMurshidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ..._appBlocProviders,
        BlocProvider<ReviewBloc>(create: (context) => ReviewBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'Al Murshid',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: const [
                  Locale('ar'),
                  Locale('en'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const SplashPage(),
              );
            },
          );
        },
      ),
    );
  }
}

final List<BlocProvider<dynamic>> _appBlocProviders = [
  BlocProvider<UserBloc>(
    create: (_) => di.sl<UserBloc>()..add(LoadUserEvent()),
  ),
  BlocProvider<ThemeBloc>(
    create: (_) => ThemeBloc(),
  ),
  BlocProvider<LocaleCubit>(
    create: (_) => LocaleCubit(),
  ),
  BlocProvider<HomeBloc>(
    create: (_) => di.sl<HomeBloc>(),
  ),
  BlocProvider<DoctorsBloc>(
    create: (_) => di.sl<DoctorsBloc>()..add(LoadDoctorsEvent()),
  ),
  BlocProvider<DiagnosticsBloc>(
    create: (_) => di.sl<DiagnosticsBloc>(),
  ),
  BlocProvider<AppointmentBloc>(
    create: (_) => di.sl<AppointmentBloc>(),
  ),
  BlocProvider<DiagnosisBloc>(
    create: (_) => DiagnosisBloc(),
  ),
  BlocProvider<NotificationBloc>(
    create: (_) => di.sl<NotificationBloc>()..add(LoadNotifications()),
  ),
  BlocProvider<MessagesBloc>(
    create: (_) => di.sl<MessagesBloc>()..add(LoadMessages()),
  ),
  BlocProvider<AuthBloc>(
    create: (_) => di.sl<AuthBloc>(),
  ),
];
