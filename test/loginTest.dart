import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_c_kelompok4/View/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpAll(() => HttpOverrides.global=null);
  testWidgets('Succes Login Widget', (WidgetTester tester) async {
  final screenSize = tester.binding.window.physicalSize / tester.binding.window.devicePixelRatio;

  await tester.binding.setSurfaceSize(screenSize);

  await tester.pumpWidget(
    ProviderScope(
      child: ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight = Device.orientation == Orientation.portrait
              ? 20.5.h
              : 12.5.h;

          return MaterialApp(
            home: SizedBox(
              width: 100.w,
              height: containerHeight,
              child: const LoginView(), 
            ),
          );
        },
      ),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.byKey(ValueKey('username')), findsOneWidget);
  expect(find.byKey(ValueKey('password')), findsOneWidget);
  expect(find.byType(ElevatedButton), findsOneWidget);

  await tester.enterText(find.byKey(ValueKey('username')), 'Omaga');
  await tester.enterText(find.byKey(ValueKey('password')), 'Omaga123');
  await tester.pump();

  await tester.tapAt(Offset(98.9, 520.7));
  await tester.pumpAndSettle(Duration(seconds: 3));
});
}
