import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../themes/app_theme.dart'; // Import the theme

class TransactionDetailsScreen extends StatefulWidget {
  final Transaction transaction;

  TransactionDetailsScreen({required this.transaction});

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _type;
  late String? _category;
  late DateTime _date;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _type = widget.transaction.type;
    _category = widget.transaction.category;
    _date = widget.transaction.date;
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details', style: Theme.of(context).textTheme.titleLarge),
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
                  _isEditing ? 'Edit Transaction' : 'Transaction Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 16),

                // Title
                _isEditing
                    ? TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.description, color: Theme.of(context).primaryColor),
                  ),
                  keyboardType: TextInputType.text,
                )
                    : _buildDetailRow(
                  context,
                  'Title',
                  widget.transaction.title,
                  Icons.description,
                ),
                SizedBox(height: 16),

                // Amount
                _isEditing
                    ? TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                )
                    : _buildDetailRow(
                  context,
                  'Amount',
                  '\₹${widget.transaction.amount.toStringAsFixed(2)}',
                  Icons.attach_money,
                  color: widget.transaction.type == 'income' ? Colors.green : Colors.red,
                ),
                SizedBox(height: 16),

                // Type
                _isEditing
                    ? DropdownButtonFormField<String>(
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
                )
                    : _buildDetailRow(
                  context,
                  'Type',
                  widget.transaction.type.capitalize(),
                  Icons.swap_horiz,
                ),
                SizedBox(height: 16),

                // Category
                _isEditing
                    ? DropdownButtonFormField<String>(
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
                )
                    : _buildDetailRow(
                  context,
                  'Category',
                  widget.transaction.category,
                  Icons.category,
                ),
                SizedBox(height: 16),

                // Date
                _isEditing
                    ? ListTile(
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
                )
                    : _buildDetailRow(
                  context,
                  'Date',
                  DateFormat('MMM dd, yyyy').format(widget.transaction.date),
                  Icons.calendar_today,
                ),
                SizedBox(height: 24),

                // Buttons
                if (!_isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _isEditing = true),
                        icon: Icon(Icons.edit),
                        label: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Transaction'),
                              content: Text('Are you sure you want to delete "${widget.transaction.title}"?'),
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
                              await financeProvider.deleteTransaction(widget.transaction.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Transaction deleted')),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text('Delete', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  )
                else
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
                          final updatedTransaction = Transaction(
                            id: widget.transaction.id,
                            title: _titleController.text.trim(),
                            amount: double.parse(_amountController.text),
                            type: _type,
                            category: _category!,
                            date: _date,
                          );
                          await financeProvider.updateTransaction(updatedTransaction);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transaction updated')),
                          );
                          setState(() => _isEditing = false);
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
                          : Text('Save Changes'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color ?? Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
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