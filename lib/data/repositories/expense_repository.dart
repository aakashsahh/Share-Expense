import 'package:share_expenses/data/datasources/local/expense_local_datasource.dart';

import '../models/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<Expense?> getExpenseById(String id);
  Future<void> addExpense(Expense expense, List<String> memberIds);
  Future<void> updateExpense(Expense expense, List<String> memberIds);
  Future<void> deleteExpense(String id);
  Future<List<Expense>> getExpensesByMember(String memberId);
  Future<Map<String, double>> getCategoryExpenses();
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<List<Expense>> getAllExpenses() async {
    return await localDataSource.getAllExpenses();
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    return await localDataSource.getExpenseById(id);
  }

  @override
  Future<void> addExpense(Expense expense, List<String> memberIds) async {
    await localDataSource.addExpense(expense, memberIds);
  }

  @override
  Future<void> updateExpense(Expense expense, List<String> memberIds) async {
    await localDataSource.updateExpense(expense, memberIds);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }

  @override
  Future<List<Expense>> getExpensesByMember(String memberId) async {
    return await localDataSource.getExpensesByMember(memberId);
  }

  @override
  Future<Map<String, double>> getCategoryExpenses() async {
    return await localDataSource.getCategoryExpenses();
  }
}
