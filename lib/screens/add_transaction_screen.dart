import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import '../themes/app_theme.dart'; // Import the theme

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'expense';
  String? _category;
  DateTime _date = DateTime.now();
  bool _isRecurring = false;
  bool _isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);
    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'New Transaction',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your income or expense',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 24),

                // Title Field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.description, color: Theme.of(context).primaryColor),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16),

                // Amount Field
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 16),

                // Type Dropdown
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.swap_horiz, color: Theme.of(context).primaryColor),
                  ),
                  items: ['income', 'expense']
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.capitalize()),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _type = value!),
                ),
                SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category, color: Theme.of(context).primaryColor),
                  ),
                  hint: Text('Select Category'),
                  items: financeProvider.categories
                      .map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value),
                ),
                SizedBox(height: 16),

                // Date Picker
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                  title: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(_date)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                ),
                SizedBox(height: 16),

                // Recurring Checkbox
                CheckboxListTile(
                  title: Text('Recurring Payment'),
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value!),
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      if (_titleController.text.isEmpty ||
                          _amountController.text.isEmpty ||
                          _category == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      try {
                        final transaction = Transaction(
                          title: _titleController.text.trim(),
                          amount: double.parse(_amountController.text),
                          type: _type,
                          category: _category!,
                          date: _date,
                        );
                        final userId = Provider.of<AuthService>(context, listen: false).currentUser?.uid;
                        await financeProvider.addTransaction(transaction, userId: userId);
                        if (_isRecurring) {
                          final notificationId = DateTime.now().millisecondsSinceEpoch;
                          await notificationService.scheduleNotification(
                            notificationId,
                            'Recurring Payment Due',
                            'Your payment for ${transaction.title} is due.',
                            _date.add(Duration(days: 30)),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transaction added successfully')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}