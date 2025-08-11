import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/repositories/expense_repository.dart';

import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc(this.repository) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await repository.getAllExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to load expenses: ${e.toString()}'));
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.addExpense(event.expense, event.memberIds);
      emit(const ExpenseOperationSuccess('Expense added successfully'));
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to add expense: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.updateExpense(event.expense, event.memberIds);
      emit(const ExpenseOperationSuccess('Expense updated successfully'));
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to update expense: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.deleteExpense(event.expenseId);
      emit(const ExpenseOperationSuccess('Expense deleted successfully'));
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError('Failed to delete expense: ${e.toString()}'));
    }
  }
}
