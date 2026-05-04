import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:almurshid/app/app.dart';
import 'package:almurshid/app/injection_container.dart' as di;

void main() {
  setUpAll(() {
    di.registerExternalDependencies();
    di.configureDependencies();
  });

  tearDownAll(() async {
    await di.sl.reset();
  });

  testWidgets('builds the app shell', (tester) async {
    await tester.pumpWidget(const AlMurshidApp());
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(AlMurshidApp), findsOneWidget);
  });
}
