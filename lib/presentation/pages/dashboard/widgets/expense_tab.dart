import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_event.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_bloc.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_event.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_state.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_event.dart';

import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/loading_widget.dart';
import '../../expense/add_expense_page.dart';
import 'expense_item.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({super.key});

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is ExpenseOperationSuccess) {
            context.read<DashboardBloc>().add(LoadDashboardData());
            context.read<MemberBloc>().add(LoadMembers());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const LoadingWidget();
          }

          if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.receipt_long,
                title: 'No Expenses Yet',
                subtitle: 'Add your first expense to get started',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseBloc>().add(LoadExpenses());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.expenses.length,
                itemBuilder: (context, index) {
                  return ExpenseItem(
                    expense: state.expenses[index],
                    onTap: () {
                      // Open edit page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddExpensePage(
                            expense: state
                                .expenses[index], // Pass the expense to edit
                          ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddExpensePage(expense: state.expenses[index]),
                        ),
                      );
                    },
                    onDelete: () {
                      _showDeleteDialog(context, state.expenses[index].id);
                    },
                  );
                },
              ),
            );
          } else if (state is ExpenseError) {
            return EmptyStateWidget(
              icon: Icons.error,
              title: state.message,
              subtitle: 'Pull to refresh and try again',
            );
          } else {
            return const EmptyStateWidget(
              icon: Icons.error,
              title: 'Something went wrong',
              subtitle: 'Pull to refresh and try again',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.error,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        child: Icon(
          Icons.receipt_long,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpense(expenseId));
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
