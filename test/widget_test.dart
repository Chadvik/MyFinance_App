import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_finance/providers/finance_provider.dart';
import 'package:my_finance/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays income and expenses', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FinanceProvider()),
        ],
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.textContaining('Income:'), findsOneWidget);
    expect(find.textContaining('Expenses:'), findsOneWidget);
    expect(find.textContaining('Balance:'), findsOneWidget);
  });
}