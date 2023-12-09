import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_c_kelompok4/View/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpAll(() => HttpOverrides.global=null);
  
  testWidgets('RegisterView Widget Test', (WidgetTester tester) async {
    final screenSize = tester.binding.window.physicalSize / tester.binding.window.devicePixelRatio;

    await tester.binding.setSurfaceSize(screenSize);

    await tester.pumpWidget(
      ProviderScope(
        child: ResponsiveSizer(
          builder: (context, orientation, deviceType) {
            final double containerHeight = Device.orientation == Orientation.portrait
                ? 100.h
                : 100.h;

            return MaterialApp(
              home: Container(
                width: 100.w,
                height: containerHeight,
                child: RegisterView(currentAddress: 'Alamat'),
              ),
            );
          },
        ),
      ),
      );
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('TanggalLahir'), findsOneWidget);
    expect(find.text('No Telp'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.enterText(find.byKey(ValueKey('username')), 'Kairi');
    await tester.enterText(find.byKey(ValueKey('email')), 'kairi@email.com');
    await tester.enterText(find.byKey(ValueKey('password')), 'kairi123');
    await tester.enterText(find.byKey(ValueKey('tanggalLahir')), '2022-03-10');
    await tester.enterText(find.byKey(ValueKey('noTelp')), '1234567890');
    await tester.enterText(find.byKey(ValueKey('gender')), 'pria');
    await tester.tapAt(Offset(354.5, 425.4));
    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tapAt(Offset(320.7, 638.1));
    await tester.pump();
    
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.enterText(find.byKey(ValueKey('address')), 'Address');

    await tester.tapAt(Offset(77.8, 556.3));
    await tester.pumpAndSettle(const Duration(seconds: 3));
   
    await tester.tapAt(Offset(242.5, 464.7));
    await tester.pumpAndSettle(Duration(seconds: 3));
  });
}
