import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:share_expenses/injection_container.dart' as di;
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_event.dart';
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
// (BuildContext context) {
//     final theme = Theme.of(context);

//     return Drawer(
//       child: Column(
//         children: [
//           // Drawer Header
//           Container(
//             height: 200,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   theme.colorScheme.primary,
//                   theme.colorScheme.primary.withOpacity(0.8),
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: theme.colorScheme.onPrimary,
//                       child: Icon(
//                         Icons.group,
//                         size: 36,
//                         color: theme.colorScheme.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Expense Sharing',
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         color: theme.colorScheme.onPrimary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Manage your group expenses',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.onPrimary.withOpacity(0.9),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Menu Items
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.dashboard),
//                   title: const Text('Dashboard'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.people),
//                   title: const Text('Members'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const MemberListPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: Icon(
//                     Icons.refresh,
//                     color: theme.colorScheme.tertiary,
//                   ),
//                   title: const Text('Reset All Data'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _showResetDialog(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.settings),
//                   title: const Text('Settings'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     // Navigate to settings
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Footer
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               'Version 1.0.0',
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: theme.colorScheme.onSurfaceVariant,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

void _showResetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset All Data'),
      content: const Text(
        'Are you sure you want to reset all data? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _resetAllData(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
}

Future<void> _resetAllData(BuildContext context) async {
  try {
    final databaseHelper = di.sl<DatabaseHelper>();
    await databaseHelper.resetDatabase();

    // Refresh dashboard
    if (context.mounted) {
      context.read<DashboardBloc>().add(LoadDashboardData());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data has been reset successfully')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset data: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
