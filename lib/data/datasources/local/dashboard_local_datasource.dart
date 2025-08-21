import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:share_expenses/data/models/category_model.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/dashboard_data.dart';
import '../../models/expense.dart';
import '../../models/fund.dart';
import '../../models/member.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardData> getDashboardData();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseHelper databaseHelper;

  DashboardLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<DashboardData> getDashboardData() async {
    final db = await databaseHelper.database;

    // Get total expenses
    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${AppConstants.expensesTable}',
    );
    final totalExpenses =
        (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Get total funds
    final fundResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${AppConstants.fundsTable}',
    );
    final totalFunds = (fundResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Calculate balance
    final totalBalance = totalFunds - totalExpenses;

    // Get recent expenses
    final expenseMaps = await db.rawQuery('''
  SELECT e.*, 
         c.id as c_id, c.name as c_name, c.color as c_color,
         c.iconCodePoint as c_iconCodePoint, 
         c.iconFontFamily as c_iconFontFamily, 
         c.type as c_type
  FROM ${AppConstants.expensesTable} e
  JOIN ${AppConstants.categoriesTable} c ON e.category_id = c.id
  ORDER BY e.date DESC
  LIMIT 10
''');

    final recentExpenses = expenseMaps.map((map) {
      final category = Category(
        id: map['c_id'] as String,
        name: map['c_name'] as String,
        color: map['c_color'] as int,
        iconCodePoint: map['c_iconCodePoint'] as int,
        iconFontFamily: map['c_iconFontFamily'] as String,
        type: map['c_type'] as String,
      );
      return Expense.fromJson(map, category: category);
    }).toList();

    // Get recent funds
    final fundMaps = await db.query(
      AppConstants.fundsTable,
      orderBy: 'date DESC',
      limit: 10,
    );
    final recentFunds = fundMaps.map((map) => Fund.fromJson(map)).toList();

    // Get member balances
    final memberBalances = await _getMemberBalances();

    // Get category expenses
    final categoryExpenses = await _getCategoryExpenses();

    return DashboardData(
      totalBalance: totalBalance,
      totalExpenses: totalExpenses,
      totalFunds: totalFunds,
      recentExpenses: recentExpenses,
      recentFunds: recentFunds,
      memberBalances: memberBalances,
      categoryExpenses: categoryExpenses,
    );
  }

  Future<List<MemberBalance>> _getMemberBalances() async {
    final db = await databaseHelper.database;

    // Get all members
    final memberMaps = await db.query(AppConstants.membersTable);
    final members = memberMaps.map((map) => Member.fromJson(map)).toList();

    List<MemberBalance> memberBalances = [];

    for (final member in members) {
      // Get member's total expenses (amount they owe)
      final expenseResult = await db.rawQuery(
        '''
        SELECT SUM(em.amount_owed) as total_expenses
        FROM ${AppConstants.expenseMembersTable} em
        WHERE em.member_id = ?
      ''',
        [member.id],
      );
      final totalExpenses =
          (expenseResult.first['total_expenses'] as num?)?.toDouble() ?? 0.0;

      // Get member's total funds (amount they contributed)
      final fundResult = await db.rawQuery(
        '''
        SELECT SUM(amount) as total_funds
        FROM ${AppConstants.fundsTable}
        WHERE member_id = ?
      ''',
        [member.id],
      );
      final totalFunds =
          (fundResult.first['total_funds'] as num?)?.toDouble() ?? 0.0;

      // Calculate balance (positive means they're owed money, negative means they owe money)
      final balance = totalFunds - totalExpenses;

      memberBalances.add(
        MemberBalance(
          member: member,
          totalExpenses: totalExpenses,
          totalFunds: totalFunds,
          balance: balance,
        ),
      );
    }

    return memberBalances;
  }

  Future<Map<Category, double>> _getCategoryExpenses() async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery('''
    SELECT 
      c.id, c.name, c.color, c.iconCodePoint, c.iconFontFamily, c.type,
      SUM(e.amount) as total_amount
    FROM ${AppConstants.expensesTable} e
    JOIN ${AppConstants.categoriesTable} c ON e.category_id = c.id
    GROUP BY c.id
  ''');

    Map<Category, double> categoryExpenses = {};
    for (var map in maps) {
      final category = Category(
        id: map['id'] as String,
        name: map['name'] as String,
        color: map['color'] as int,
        iconCodePoint: map['iconCodePoint'] as int,
        iconFontFamily: map['iconFontFamily'] as String,
        type: map['type'] as String,
      );

      categoryExpenses[category] = (map['total_amount'] as num).toDouble();
    }

    return categoryExpenses;
  }
}
