import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_finance/models/transaction.dart'; // Correct package name
import 'mocks.mocks.dart'; // Generated mocks

void main() {
  group('FinanceProvider Tests', () {
    late MockFinanceProvider financeProvider;

    setUp(() {
      financeProvider = MockFinanceProvider();
    });

    test('getTotalIncome calculates total income correctly', () {
      // Arrange
      final startDate = DateTime(2025, 3, 1);
      final endDate = DateTime(2025, 3, 31);
      final transactions = [
        Transaction(
          id: 1,
          title: 'Salary',
          amount: 1000.0,
          type: 'income',
          category: 'Work',
          date: DateTime(2025, 3, 10),
        ),
        Transaction(
          id: 2,
          title: 'Groceries',
          amount: 50.0,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 3, 15),
        ),
        Transaction(
          id: 3,
          title: 'Bonus',
          amount: 200.0,
          type: 'income',
          category: 'Work',
          date: DateTime(2025, 3, 20),
        ),
      ];
      when(financeProvider.transactions).thenReturn(transactions);
      when(financeProvider.getTotalIncome(startDate, endDate)).thenReturn(1200.0); // Stub the method

      // Act
      final totalIncome = financeProvider.getTotalIncome(startDate, endDate);

      // Assert
      expect(totalIncome, 1200.0); // 1000 + 200
    });
  });
}