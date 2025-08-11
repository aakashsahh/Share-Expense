import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/fund/bloc/fund_bloc.dart';
import 'package:share_expenses/presentation/bloc/fund/bloc/fund_event.dart';
import 'package:share_expenses/presentation/bloc/fund/bloc/fund_state.dart';

import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/loading_widget.dart';
import '../../fund/add_fund_page.dart';
import 'fund_item.dart';

class FundTab extends StatelessWidget {
  const FundTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FundBloc, FundState>(
        listener: (context, state) {
          if (state is FundError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is FundOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FundLoading) {
            return const LoadingWidget();
          }

          if (state is FundLoaded) {
            if (state.funds.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.account_balance_wallet,
                title: 'No Funds Yet',
                subtitle: 'Add your first fund contribution',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FundBloc>().add(LoadFunds());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.funds.length,
                itemBuilder: (context, index) {
                  return FundItem(
                    fund: state.funds[index],
                    onTap: () {
                      // Navigate to fund details or edit
                    },
                    onDelete: () {
                      _showDeleteDialog(context, state.funds[index].id);
                    },
                  );
                },
              ),
            );
          }

          return const EmptyStateWidget(
            icon: Icons.error,
            title: 'Something went wrong',
            subtitle: 'Pull to refresh and try again',
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddFundPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String fundId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fund'),
        content: const Text('Are you sure you want to delete this fund?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FundBloc>().add(DeleteFund(fundId));
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
