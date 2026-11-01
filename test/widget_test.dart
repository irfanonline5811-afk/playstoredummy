import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:playstore3/main.dart';

void main() {
  testWidgets('PlayStore home loads with scrollable header and bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify playstore title is shown initially
    expect(find.text('playstore'), findsOneWidget);

    // Verify category button exists
    expect(find.text('Game'), findsWidgets);

    // Verify bottom navigation bar items
    expect(find.text('App'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify NestedScrollView exists
    expect(find.byType(NestedScrollView), findsOneWidget);

    // Verify SliverAppBar exists
    expect(find.byType(SliverAppBar), findsOneWidget);

    // Scroll down on the main content
    await tester.drag(find.byType(NestedScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();

    // Bottom navigation bar still visible
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
