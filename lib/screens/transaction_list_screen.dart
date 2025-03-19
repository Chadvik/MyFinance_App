import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../themes/app_theme.dart'; // Import the theme
import 'transaction_details_screen.dart'; // Import the new details screen

class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: financeProvider.transactions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              'No Transactions Yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add a transaction to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: financeProvider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = financeProvider.transactions[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                transaction.type == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaction.type == 'income' ? Colors.green : Colors.red,
              ),
              title: Text(
                transaction.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${transaction.formattedDate} • ${transaction.category}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                '${transaction.type == 'income' ? '+' : '-'}\₹${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: transaction.type == 'income' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailsScreen(transaction: transaction),
                  ),
                );
              },
              onLongPress: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Transaction'),
                    content: Text('Are you sure you want to delete "${transaction.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await financeProvider.deleteTransaction(transaction.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}