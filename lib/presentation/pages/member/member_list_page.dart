import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            },
          ),
        ],
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
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
        builder: (context, state) {
          if (state is MemberLoading) {
            return const LoadingWidget();
          }

          if (state is MemberLoaded) {
            if (state.members.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.people,
                title: 'No Members Yet',
                subtitle: 'Add your first member to get started',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MemberBloc>().add(LoadMembers());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  return MemberCard(
                    member: state.members[index],
                    onTap: () {
                      // Navigate to member details
                    },
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMemberPage(member: state.members[index]),
                        ),
                      );
                    },
                    onDelete: () {
                      _showDeleteDialog(
                        context,
                        state.members[index].id,
                        state.members[index].name,
                      );
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMemberPage()),
          );
        },
        child: const Icon(Icons.person_add),
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
