import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('ar', null);

  di.registerExternalDependencies();
  di.configureDependencies();

  runApp(
    DevicePreview(
      builder: (_) => const AlMurshidApp(),
    ),
  );
}
