import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double totalExpenses;
  final double totalFunds;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalExpenses,
    required this.totalFunds,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              // Main Balance
              Column(
                children: [
                  Text(
                    'Total Balance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(widget.totalBalance),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: widget.totalBalance >= 0
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Expenses and Funds Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Total Expenses',
                      widget.totalExpenses,
                      Icons.trending_down,
                      theme.colorScheme.error,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Total Funds',
                      widget.totalFunds,
                      Icons.trending_up,
                      theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
