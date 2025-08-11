import 'package:share_expenses/core/databases/database_helper.dart';

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
    final expenseMaps = await db.query(
      AppConstants.expensesTable,
      orderBy: 'date DESC',
      limit: 10,
    );
    final recentExpenses = expenseMaps
        .map((map) => Expense.fromJson(map))
        .toList();

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

  Future<Map<String, double>> _getCategoryExpenses() async {
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
}
