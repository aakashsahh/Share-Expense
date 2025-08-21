import 'package:share_expenses/core/constants/app_constants.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:uuid/uuid.dart';

import '../../models/category_model.dart';
import '../../models/expense.dart';
import '../../models/expense_member.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getAllExpenses();
  Future<Expense?> getExpenseById(String id);
  Future<void> addExpense(Expense expense, List<String> memberIds);
  Future<void> updateExpense(Expense expense, List<String> memberIds);
  Future<void> deleteExpense(String id);
  Future<List<Expense>> getExpensesByMember(String memberId);
  Future<Map<Category, double>> getCategoryExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid uuid = const Uuid();

  ExpenseLocalDataSourceImpl(this.databaseHelper);

  // 🔹 Get all expenses + join categories
  @override
  Future<List<Expense>> getAllExpenses() async {
    final db = await databaseHelper.database;

    final maps = await db.rawQuery('''
      SELECT e.*, 
             c.id as c_id, c.name as c_name, c.iconCodePoint, 
             c.iconFontFamily, c.type, c.color
      FROM ${AppConstants.expensesTable} e
      JOIN ${AppConstants.categoriesTable} c ON e.category_id = c.id
      ORDER BY e.date DESC
    ''');

    List<Expense> expenses = [];
    for (var map in maps) {
      final category = Category(
        id: map['c_id'] as String,
        name: map['c_name'] as String,
        iconCodePoint: map['iconCodePoint'] as int,
        iconFontFamily: map['iconFontFamily'] as String,
        type: map['type'] as String,
        color: map['color'] as int,
      );

      final expense = Expense.fromJson(map, category: category);
      final involvedMembers = await _getExpenseMembers(expense.id);

      expenses.add(expense.copyWith(involvedMembers: involvedMembers));
    }

    return expenses;
  }

  // 🔹 Get single expense + category
  @override
  Future<Expense?> getExpenseById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT e.*, 
             c.id as c_id, c.name as c_name, c.iconCodePoint, 
             c.iconFontFamily, c.type, c.color
      FROM ${AppConstants.expensesTable} e
      JOIN ${AppConstants.categoriesTable} c ON e.category_id = c.id
      WHERE e.id = ?
      LIMIT 1
    ''',
      [id],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;

    final category = Category(
      id: map['c_id'] as String,
      name: map['c_name'] as String,
      iconCodePoint: map['iconCodePoint'] as int,
      iconFontFamily: map['iconFontFamily'] as String,
      type: map['type'] as String,
      color: map['color'] as int,
    );

    final expense = Expense.fromJson(map, category: category);
    final involvedMembers = await _getExpenseMembers(expense.id);

    return expense.copyWith(involvedMembers: involvedMembers);
  }

  // 🔹 Add expense with categoryId
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

  // 🔹 Update expense
  @override
  Future<void> updateExpense(Expense expense, List<String> memberIds) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        AppConstants.expensesTable,
        expense.toJson(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );

      // Refresh expense members
      await txn.delete(
        AppConstants.expenseMembersTable,
        where: 'expense_id = ?',
        whereArgs: [expense.id],
      );

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

  // 🔹 Delete expense
  @override
  Future<void> deleteExpense(String id) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      await txn.delete(
        AppConstants.expenseMembersTable,
        where: 'expense_id = ?',
        whereArgs: [id],
      );

      await txn.delete(
        AppConstants.expensesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // 🔹 Get expenses by member + join categories
  @override
  Future<List<Expense>> getExpensesByMember(String memberId) async {
    final db = await databaseHelper.database;

    final maps = await db.rawQuery(
      '''
      SELECT DISTINCT e.*, 
             c.id as c_id, c.name as c_name, c.iconCodePoint, 
             c.iconFontFamily, c.type, c.color
      FROM ${AppConstants.expensesTable} e
      INNER JOIN ${AppConstants.expenseMembersTable} em 
        ON e.id = em.expense_id
      JOIN ${AppConstants.categoriesTable} c 
        ON e.category_id = c.id
      WHERE em.member_id = ?
      ORDER BY e.date DESC
    ''',
      [memberId],
    );

    List<Expense> expenses = [];
    for (var map in maps) {
      final category = Category(
        id: map['c_id'] as String,
        name: map['c_name'] as String,
        iconCodePoint: map['iconCodePoint'] as int,
        iconFontFamily: map['iconFontFamily'] as String,
        type: map['type'] as String,
        color: map['color'] as int,
      );

      final expense = Expense.fromJson(map, category: category);
      final involvedMembers = await _getExpenseMembers(expense.id);

      expenses.add(expense.copyWith(involvedMembers: involvedMembers));
    }

    return expenses;
  }

  // 🔹 Category expense breakdown (returns Map<Category, totalAmount>)
  @override
  Future<Map<Category, double>> getCategoryExpenses() async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery('''
      SELECT c.id as c_id, c.name as c_name, c.iconCodePoint,
             c.iconFontFamily, c.type, c.color,
             SUM(e.amount) as total_amount
      FROM ${AppConstants.expensesTable} e
      JOIN ${AppConstants.categoriesTable} c ON e.category_id = c.id
      GROUP BY c.id
    ''');

    Map<Category, double> categoryExpenses = {};
    for (var map in maps) {
      final category = Category(
        id: map['c_id'] as String,
        name: map['c_name'] as String,
        iconCodePoint: map['iconCodePoint'] as int,
        iconFontFamily: map['iconFontFamily'] as String,
        type: map['type'] as String,
        color: map['color'] as int,
      );

      categoryExpenses[category] = (map['total_amount'] as num).toDouble();
    }

    return categoryExpenses;
  }

  // 🔹 Helper: get members for an expense
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
