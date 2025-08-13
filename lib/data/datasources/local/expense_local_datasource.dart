import 'package:share_expenses/core/constants/app_constants.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:uuid/uuid.dart';

import '../../models/expense.dart';
import '../../models/expense_member.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getAllExpenses();
  Future<Expense?> getExpenseById(String id);
  Future<void> addExpense(Expense expense, List<String> memberIds);
  Future<void> updateExpense(Expense expense, List<String> memberIds);
  Future<void> deleteExpense(String id);
  Future<List<Expense>> getExpensesByMember(String memberId);
  Future<Map<String, double>> getCategoryExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid uuid = const Uuid();

  ExpenseLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Expense>> getAllExpenses() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.expensesTable,
      orderBy: 'date DESC',
    );

    List<Expense> expenses = [];
    for (var map in maps) {
      final expense = Expense.fromJson(map);
      final involvedMembers = await _getExpenseMembers(expense.id);
      expenses.add(expense.copyWith(involvedMembers: involvedMembers));
    }

    return expenses;
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.expensesTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final expense = Expense.fromJson(maps.first);
    final involvedMembers = await _getExpenseMembers(expense.id);
    return expense.copyWith(involvedMembers: involvedMembers);
  }

  @override
  Future<void> addExpense(Expense expense, List<String> memberIds) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      final expenseWithId = expense.copyWith(
        id: expense.id.isEmpty ? uuid.v4() : expense.id,
      );

      // Insert expense
      await txn.insert(AppConstants.expensesTable, expenseWithId.toJson());

      // Insert expense members with split amounts
      final splitAmount = expense.amount / memberIds.length;
      for (final memberId in memberIds) {
        final expenseMember = ExpenseMember(
          id: uuid.v4(),
          expenseId: expenseWithId.id,
          memberId: memberId,
          amountOwed: splitAmount,
        );
        await txn.insert(
          AppConstants.expenseMembersTable,
          expenseMember.toJson(),
        );
      }
    });
  }

  @override
  Future<void> updateExpense(Expense expense, List<String> memberIds) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      // Update expense
      await txn.update(
        AppConstants.expensesTable,
        expense.toJson(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );

      // Delete existing expense members
      await txn.delete(
        AppConstants.expenseMembersTable,
        where: 'expense_id = ?',
        whereArgs: [expense.id],
      );

      // Insert new expense members
      final splitAmount = expense.amount / memberIds.length;
      for (final memberId in memberIds) {
        final expenseMember = ExpenseMember(
          id: uuid.v4(),
          expenseId: expense.id,
          memberId: memberId,
          amountOwed: splitAmount,
        );
        await txn.insert(
          AppConstants.expenseMembersTable,
          expenseMember.toJson(),
        );
      }
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      // First delete from expense_members table
      await txn.delete(
        AppConstants.expenseMembersTable,
        where: 'expense_id = ?',
        whereArgs: [id],
      );

      // Then delete from expenses table
      await txn.delete(
        AppConstants.expensesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  @override
  Future<List<Expense>> getExpensesByMember(String memberId) async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT DISTINCT e.* FROM ${AppConstants.expensesTable} e
      INNER JOIN ${AppConstants.expenseMembersTable} em ON e.id = em.expense_id
      WHERE em.member_id = ?
      ORDER BY e.date DESC
    ''',
      [memberId],
    );

    List<Expense> expenses = [];
    for (var map in maps) {
      final expense = Expense.fromJson(map);
      final involvedMembers = await _getExpenseMembers(expense.id);
      expenses.add(expense.copyWith(involvedMembers: involvedMembers));
    }

    return expenses;
  }

  @override
  Future<Map<String, double>> getCategoryExpenses() async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery('''
      SELECT category, SUM(amount) as total_amount
      FROM ${AppConstants.expensesTable}
      GROUP BY category
    ''');

    Map<String, double> categoryExpenses = {};
    for (var map in maps) {
      categoryExpenses[map['category'] as String] = (map['total_amount'] as num)
          .toDouble();
    }

    return categoryExpenses;
  }

  Future<List<String>> _getExpenseMembers(String expenseId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.expenseMembersTable,
      columns: ['member_id'],
      where: 'expense_id = ?',
      whereArgs: [expenseId],
    );

    return maps.map((map) => map['member_id'] as String).toList();
  }
}
