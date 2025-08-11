import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../widgets/common/loading_widget.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const LoadingWidget();
        }

        if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member Expenses Chart
                _buildMemberExpensesChart(context, state),

                const SizedBox(height: 24),

                // Category Expenses Chart
                _buildCategoryExpensesChart(context, state),

                const SizedBox(height: 24),

                // Member Balances
                _buildMemberBalances(context, state),
              ],
            ),
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildMemberExpensesChart(
    BuildContext context,
    DashboardLoaded state,
  ) {
    final theme = Theme.of(context);

    if (state.data.memberBalances.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Member Expenses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      state.data.memberBalances
                          .map((mb) => mb.totalExpenses)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      //getTooltipColor: theme.colorScheme.surface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final memberBalance =
                            state.data.memberBalances[group.x.toInt()];
                        return BarTooltipItem(
                          '${memberBalance.member.name}\n${CurrencyFormatter.format(rod.toY)}',
                          TextStyle(color: theme.colorScheme.onSurface),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() <
                              state.data.memberBalances.length) {
                            final member =
                                state.data.memberBalances[value.toInt()].member;
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                member.name.length > 8
                                    ? '${member.name.substring(0, 8)}...'
                                    : member.name,
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toStringAsFixed(0)}k',
                            style: theme.textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: state.data.memberBalances.asMap().entries.map((
                    entry,
                  ) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.totalExpenses,
                          color: theme.colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryExpensesChart(
    BuildContext context,
    DashboardLoaded state,
  ) {
    final theme = Theme.of(context);

    if (state.data.categoryExpenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final sections = state.data.categoryExpenses.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final percentage = (amount / state.data.totalExpenses * 100);

      return PieChartSectionData(
        color: AppColors.getCategoryColor(category),
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.data.categoryExpenses.entries.map((entry) {
                      final category = entry.key;
                      final amount = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.getCategoryColor(category),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: theme.textTheme.labelMedium,
                                  ),
                                  Text(
                                    CurrencyFormatter.format(amount),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberBalances(BuildContext context, DashboardLoaded state) {
    final theme = Theme.of(context);

    if (state.data.memberBalances.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Member Balances',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...state.data.memberBalances.map((memberBalance) {
              final isPositive = memberBalance.balance >= 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        memberBalance.member.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memberBalance.member.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Paid: ${CurrencyFormatter.format(memberBalance.totalFunds)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Owes: ${CurrencyFormatter.format(memberBalance.totalExpenses)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(memberBalance.balance.abs()),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.error,
                          ),
                        ),
                        Text(
                          isPositive ? 'Gets back' : 'Should pay',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isPositive
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
