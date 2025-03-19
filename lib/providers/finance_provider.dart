import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/database.dart';
import '../services/sync_service.dart'; // Import SyncService for Firestore sync

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  final SyncService _syncService = SyncService(); // Instance of SyncService

  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;

  FinanceProvider() {
    loadData();
  }

  // Load data from local database and optionally sync with Firestore
  Future<void> loadData({String? userId}) async {
    // Load from local SQLite
    _transactions = await DatabaseService.instance.getTransactions();
    _categories = await DatabaseService.instance.getCategories();

    // If userId is provided, sync with Firestore
    if (userId != null) {
      await _syncData(userId); // Push local data to Firestore
      await _mergeCloudData(userId); // Fetch and merge Firestore data into local
      // Reload local data after merging
      _transactions = await DatabaseService.instance.getTransactions();
      _categories = await DatabaseService.instance.getCategories();
    }

    notifyListeners();
  }

  // Sync local data to Firestore
  Future<void> _syncData(String userId) async {
    await _syncService.syncTransactions(_transactions, userId);
    await _syncService.syncCategories(_categories, userId);
  }

  // Fetch data from Firestore and merge into local SQLite
  Future<void> _mergeCloudData(String userId) async {
    final cloudTransactions = await _syncService.fetchTransactions(userId);
    final cloudCategories = await _syncService.fetchCategories(userId);

    // Merge transactions
    for (var cloudTransaction in cloudTransactions) {
      if (!_transactions.any((local) => local.id == cloudTransaction.id)) {
        await DatabaseService.instance.insertTransaction(cloudTransaction);
      } else {
        // Optionally update local if cloud version is newer (requires timestamp)
        await DatabaseService.instance.updateTransaction(cloudTransaction);
      }
    }

    // Merge categories
    for (var cloudCategory in cloudCategories) {
      if (!_categories.any((local) => local.id == cloudCategory.id)) {
        await DatabaseService.instance.insertCategory(cloudCategory);
      } else {
        await DatabaseService.instance.updateCategory(cloudCategory);
      }
    }
  }

  // Transaction CRUD
  Future<void> addTransaction(Transaction transaction, {String? userId}) async {
    await DatabaseService.instance.insertTransaction(transaction);
    await loadData(userId: userId); // Reload and sync
  }

  Future<void> updateTransaction(Transaction transaction, {String? userId}) async {
    await DatabaseService.instance.updateTransaction(transaction);
    await loadData(userId: userId); // Reload and sync
  }

  Future<void> deleteTransaction(int id, {String? userId}) async {
    await DatabaseService.instance.deleteTransaction(id);
    if (userId != null) {
      await _syncService.deleteTransaction(userId, id); // Delete from Firestore
    }
    await loadData(userId: userId); // Reload and sync
  }

  // Category CRUD
  Future<void> addCategory(Category category, {String? userId}) async {
    await DatabaseService.instance.insertCategory(category);
    await loadData(userId: userId); // Reload and sync
  }

  Future<void> updateCategory(Category category, {String? userId}) async {
    await DatabaseService.instance.updateCategory(category);
    await loadData(userId: userId); // Reload and sync
  }

  Future<void> deleteCategory(int id, {String? userId}) async {
    await DatabaseService.instance.deleteCategory(id);
    if (userId != null) {
      await _syncService.deleteCategory(userId, id); // Delete from Firestore
    }
    await loadData(userId: userId); // Reload and sync
  }

  // Financial Calculations
  double getTotalIncome(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.type == 'income' && t.date.isAfter(start) && t.date.isBefore(end))
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.type == 'expense' && t.date.isAfter(start) && t.date.isBefore(end))
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getSpendingByCategory(DateTime start, DateTime end) {
    final Map<String, double> spending = {};
    for (var t in _transactions.where((t) => t.type == 'expense' && t.date.isAfter(start) && t.date.isBefore(end))) {
      spending[t.category] = (spending[t.category] ?? 0) + t.amount;
    }
    return spending;
  }


}