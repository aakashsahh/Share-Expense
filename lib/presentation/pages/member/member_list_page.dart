import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/models/dashboard_data.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_event.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_state.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_event.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_state.dart';

import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/loading_widget.dart';
import 'add_member_page.dart';
import 'widgets/member_card.dart';

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MemberBloc>().add(LoadMembers());
              context.read<DashboardBloc>().add(LoadDashboardData());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MemberBloc, MemberState>(
            listener: (context, state) {
              if (state is MemberError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              } else if (state is MemberOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<MemberBloc, MemberState>(
          builder: (context, memberState) {
            return BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, dashboardState) {
                if (memberState is MemberLoading ||
                    dashboardState is DashboardLoading) {
                  return const LoadingWidget();
                }

                if (memberState is MemberLoaded &&
                    dashboardState is DashboardLoaded) {
                  if (memberState.members.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.people,
                      title: 'No Members Yet',
                      subtitle: 'Add your first member to get started',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<MemberBloc>().add(LoadMembers());
                      context.read<DashboardBloc>().add(LoadDashboardData());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: memberState.members.length,
                      itemBuilder: (context, index) {
                        final member = memberState.members[index];

                        // Find matching financial data
                        final balanceData = dashboardState.data.memberBalances
                            .firstWhere(
                              (mb) => mb.member.id == member.id,
                              orElse: () => MemberBalance(
                                member: member,
                                totalFunds: 0,
                                totalExpenses: 0,
                                balance: 0,
                              ),
                            );

                        return MemberCard(
                          member: member,
                          funds: balanceData.totalFunds,
                          expenses: balanceData.totalExpenses,
                          balance: balanceData.balance,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMemberPage(member: member),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMemberPage(member: member),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteDialog(context, member.id, member.name);
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMemberPage()),
          );
        },
        child: Icon(
          Icons.person_add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String memberId,
    String memberName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text('Are you sure you want to delete $memberName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MemberBloc>().add(DeleteMember(memberId));
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
