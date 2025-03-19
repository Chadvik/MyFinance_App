import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import '../models/transaction.dart';
import '../models/category.dart';

class SyncService {
  final fs.CollectionReference _transactionsCollection =
  fs.FirebaseFirestore.instance.collection('transactions');
  final fs.CollectionReference _categoriesCollection =
  fs.FirebaseFirestore.instance.collection('categories');

  Future<void> syncTransactions(List<Transaction> transactions, String userId) async {
    try {
      for (var transaction in transactions) {
        final docId = userId + '_' + transaction.id.toString();
        await _transactionsCollection.doc(docId).set(transaction.toMap());
      }
    } catch (e) {
      print('Error syncing transactions: $e');
      rethrow;
    }
  }

  Future<void> syncCategories(List<Category> categories, String userId) async {
    try {
      for (var category in categories) {
        final docId = userId + '_' + category.id.toString();
        await _categoriesCollection.doc(docId).set(category.toMap());
      }
    } catch (e) {
      print('Error syncing categories: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String userId, int transactionId) async {
    try {
      final docId = userId + '_' + transactionId.toString();
      await _transactionsCollection.doc(docId).delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String userId, int categoryId) async {
    try {
      final docId = userId + '_' + categoryId.toString();
      await _categoriesCollection.doc(docId).delete();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  Future<List<Transaction>> fetchTransactions(String userId) async {
    try {
      final snapshot = await _transactionsCollection.get();
      final userTransactions = snapshot.docs
          .where((doc) => doc.id.startsWith(userId + '_'))
          .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return userTransactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

  Future<List<Category>> fetchCategories(String userId) async {
    try {
      final snapshot = await _categoriesCollection.get();
      final userCategories = snapshot.docs
          .where((doc) => doc.id.startsWith(userId + '_'))
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return userCategories;
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}