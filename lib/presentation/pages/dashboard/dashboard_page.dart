import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_event.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_state.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_event.dart';
import 'package:share_expenses/presentation/pages/member/add_member_page.dart';
import 'package:share_expenses/presentation/widgets/common/custom_drawer.dart';

import 'widgets/balance_card.dart';
import 'widgets/expense_tab.dart';
import 'widgets/fund_tab.dart';
import 'widgets/report_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load initial data
    context.read<DashboardBloc>().add(LoadDashboardData());
    context.read<MemberBloc>().add(LoadMembers());
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Expense'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMemberPage()),
              );
            },
            icon: Icon(Icons.group_add_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(LoadDashboardData());
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Balance Card
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                return BalanceCard(
                  totalBalance: state.data.totalBalance,
                  totalExpenses: state.data.totalExpenses,
                  totalFunds: state.data.totalFunds,
                );
              }
              return const BalanceCard(
                totalBalance: 0,
                totalExpenses: 0,
                totalFunds: 0,
              );
            },
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(icon: Icon(Icons.receipt_long), text: 'Expenses'),
                Tab(icon: Icon(Icons.wallet), text: 'Funds'),
                Tab(icon: Icon(Icons.analytics_outlined), text: 'Reports'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [ExpenseTab(), FundTab(), ReportTab()],
            ),
          ),
        ],
      ),
    );
  }
}
