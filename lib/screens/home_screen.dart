import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/finance_provider.dart';
import '../services/auth_service.dart';
import '../themes/app_theme.dart'; // Import the theme (used via Theme.of(context) from main.dart)

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final totalIncome = financeProvider.getTotalIncome(startOfMonth, endOfMonth);
    final totalExpenses = financeProvider.getTotalExpenses(startOfMonth, endOfMonth);
    final netBalance = totalIncome - totalExpenses;
    final spendingByCategory = financeProvider.getSpendingByCategory(startOfMonth, endOfMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyFinance', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildSummaryRow(
                      context,
                      'Income',
                      totalIncome,
                      Icons.arrow_upward,
                      Colors.green,
                    ),
                    SizedBox(height: 8),
                    _buildSummaryRow(
                      context,
                      'Expenses',
                      totalExpenses,
                      Icons.arrow_downward,
                      Colors.red,
                    ),
                    Divider(height: 20),
                    _buildSummaryRow(
                      context,
                      'Balance',
                      netBalance,
                      Icons.account_balance,
                      netBalance >= 0 ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Spending by Category
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending by Category',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: spendingByCategory.isEmpty
                              ? [
                            PieChartSectionData(
                              value: 1,
                              title: 'No Data',
                              color: Colors.grey.shade400,
                              radius: 60,
                              titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ]
                              : spendingByCategory.entries.map((e) {
                            final index = spendingByCategory.keys.toList().indexOf(e.key);
                            return PieChartSectionData(
                              value: e.value,
                              title: '${e.key}\n\₹${e.value.toStringAsFixed(2)}',
                              // color: Colors.primaries[index % Colors.primaries.length],
                              // color: subtleColors[index % subtleColors.length], // Use subtle colors
                              color: AppTheme.subtleColors[index % AppTheme.subtleColors.length], // Use from AppTheme
                              radius: 60,
                              titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_transaction'),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).cardColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        ],
        currentIndex: 0, // Home is selected
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/transactions');
          if (index == 2) Navigator.pushNamed(context, '/categories');
        },
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '\₹${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}