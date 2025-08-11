import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;
  final List<String> memberIds;

  const AddExpense(this.expense, this.memberIds);

  @override
  List<Object> get props => [expense, memberIds];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;
  final List<String> memberIds;

  const UpdateExpense(this.expense, this.memberIds);

  @override
  List<Object> get props => [expense, memberIds];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  const DeleteExpense(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}
