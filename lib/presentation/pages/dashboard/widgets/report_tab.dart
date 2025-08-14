import 'dart:io';

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
    double getOptimalInterval(double maxValue) {
      if (maxValue <= 100) {
        return 10;
      } else if (maxValue <= 500) {
        return 100;
      } else if (maxValue <= 1000) {
        return 200; // Small values, smaller interval
      } else if (maxValue <= 5000) {
        return 1000; // Medium range
      } else if (maxValue <= 20000) {
        return 2000; // Larger range
      } else if (maxValue <= 50000) {
        return 5000; // Even larger
      } else if (maxValue <= 100000) {
        return 10000;
      } else if (maxValue <= 500000) {
        return 50000;
      } else if (maxValue <= 1000000) {
        return 100000;
      } else if (maxValue <= 5000000) {
        return 500000; // Very large values
      } else if (maxValue <= 10000000) {
        // 1 Crore
        return 1000000;
      } else if (maxValue <= 25000000) {
        // 2.5 Cr
        return 2500000;
      } else if (maxValue <= 50000000) {
        // 5 Cr
        return 5000000;
      } else if (maxValue <= 100000000) {
        // 10 Cr
        return 10000000;
      } else if (maxValue <= 250000000) {
        // 25 Cr
        return 25000000;
      } else if (maxValue <= 500000000) {
        // 50 Cr
        return 50000000;
      } else {
        return 100000000; // 10 Cr+
      }
    }

    double getMaxValue(List<double> dataPoints) {
      return dataPoints.isEmpty
          ? 0
          : dataPoints.reduce((a, b) => a > b ? a : b); // add buffer
    }

    final barGraphData = state.data.memberBalances;
    final expenses = state.data.memberBalances
        .map((mb) => mb.totalExpenses)
        .toList();
    final maxValue = getMaxValue(expenses);
    final interval = getOptimalInterval(maxValue);
    final adjustedMaxY = maxValue % interval == 0
        ? maxValue
        : ((maxValue / interval).ceil() * interval).toDouble();

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
            AspectRatio(
              aspectRatio: 1.3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: barGraphData.length > 9
                      ? barGraphData.length * 66
                      : barGraphData.length * 78,

                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: adjustedMaxY,

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
                                final member = state
                                    .data
                                    .memberBalances[value.toInt()]
                                    .member;
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
                            interval: interval,
                            reservedSize: 80,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 0,
                                  top: 12,
                                ),
                                child: Text(
                                  'Rs ${value.toInt()}',
                                  // value <= 999
                                  //     ? 'Rs${value.toInt()}'
                                  //     : 'Rs${(value / 1000).toStringAsFixed(0)}k',
                                  style: theme.textTheme.labelMedium,
                                ),
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
                            // BarChartRodData(
                            //   toY: entry.value.totalFunds,
                            //   color: theme.colorScheme.tertiary,
                            //   width: 20,
                            //   borderRadius: const BorderRadius.vertical(
                            //     top: Radius.circular(4),
                            //   ),
                            // ),
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
      elevation: 3,
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
              final imagePath = memberBalance.member.imagePath;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath))
                          : null,
                      child: imagePath == null
                          ? Text(
                              memberBalance.member.name
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
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
                          SizedBox(height: 4),
                          Text(
                            'Paid: ${CurrencyFormatter.format(memberBalance.totalFunds)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Owes: ${CurrencyFormatter.format(memberBalance.totalExpenses)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
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
