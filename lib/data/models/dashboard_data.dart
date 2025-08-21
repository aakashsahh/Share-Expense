import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/category_model.dart';

import 'expense.dart';
import 'fund.dart';
import 'member.dart';

class DashboardData extends Equatable {
  final double totalBalance;
  final double totalExpenses;
  final double totalFunds;
  final List<Expense> recentExpenses;
  final List<Fund> recentFunds;
  final List<MemberBalance> memberBalances;
  final Map<Category, double> categoryExpenses;

  const DashboardData({
    required this.totalBalance,
    required this.totalExpenses,
    required this.totalFunds,
    required this.recentExpenses,
    required this.recentFunds,
    required this.memberBalances,
    required this.categoryExpenses,
  });

  @override
  List<Object?> get props => [
    totalBalance,
    totalExpenses,
    totalFunds,
    recentExpenses,
    recentFunds,
    memberBalances,
    categoryExpenses,
  ];
}

class MemberBalance extends Equatable {
  final Member member;
  final double totalExpenses;
  final double totalFunds;
  final double balance; // funds - expenses

  const MemberBalance({
    required this.member,
    required this.totalExpenses,
    required this.totalFunds,
    required this.balance,
  });

  @override
  List<Object?> get props => [member, totalExpenses, totalFunds, balance];
}
