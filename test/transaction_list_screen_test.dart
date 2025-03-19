import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:my_finance/models/transaction.dart'; // Correct package name
import 'package:my_finance/providers/finance_provider.dart'; // Correct package name
import 'package:my_finance/screens/transaction_list_screen.dart'; // Correct package name
import 'package:my_finance/themes/app_theme.dart'; // Correct package name
import 'mocks.mocks.dart'; // Generated mocks

void main() {
  group('TransactionListScreen Widget Tests', () {
    late MockFinanceProvider financeProvider;

    setUp(() {
      financeProvider = MockFinanceProvider();
    });

    // Helper method to wrap widget with providers and theme
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: ChangeNotifierProvider<FinanceProvider>.value(
          value: financeProvider,
          child: child,
        ),
      );
    }

    testWidgets('displays empty state when no transactions exist', (WidgetTester tester) async {
      // Arrange
      when(financeProvider.transactions).thenReturn([]);

      // Act
      await tester.pumpWidget(createTestWidget(TransactionListScreen()));
      await tester.pumpAndSettle(); // Ensure all animations complete

      // Assert
      expect(find.text('No Transactions Yet'), findsOneWidget);
      expect(find.text('Add a transaction to get started'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('displays transaction details when transactions exist', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 1,
        title: 'Salary',
        amount: 1000.0,
        type: 'income',
        category: 'Work',
        date: DateTime(2025, 3, 10),
      );
      when(financeProvider.transactions).thenReturn([transaction]);

      // Act
      await tester.pumpWidget(createTestWidget(TransactionListScreen()));
      await tester.pumpAndSettle();

      // Debug: Print all Text widgets
      final textWidgets = find.byType(Text).evaluate().map((e) => (e.widget as Text).data).toList();
      print('Rendered text widgets: $textWidgets');

      // Assert
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('+₹1000.00'), findsOneWidget);
      expect(find.text('${transaction.formattedDate} • Work'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('No Transactions Yet'), findsNothing);
    });
  });
}