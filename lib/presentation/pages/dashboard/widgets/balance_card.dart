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

class _BalanceCardState extends State<BalanceCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = widget.totalBalance >= 0;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (isPositive ? Colors.green : Colors.red).withValues(
                        alpha: 0.05 + (_pulseAnimation.value * 0.05),
                      ),
                      (isPositive ? Colors.teal : Colors.deepOrange).withValues(
                        alpha: 0.03 + (_pulseAnimation.value * 0.03),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Main card content
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surfaceContainer,
              border: Border.all(color: theme.colorScheme.primaryContainer),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Header with balance
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Total Balance',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(
                                      milliseconds: 1000,
                                    ),
                                    tween: Tween(
                                      begin: 0,
                                      end: widget.totalBalance,
                                    ),
                                    curve: Curves.easeOutQuart,
                                    builder: (context, value, child) {
                                      return FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          CurrencyFormatter.format(value),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                color: isPositive
                                                    ? Colors.green.shade700
                                                    : Colors.red.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                          maxLines: 1,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Stats row with creative divider
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactStatItem(
                                context,
                                'Expenses',
                                widget.totalExpenses,
                                Icons.arrow_upward,
                                Colors.red.shade600,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withValues(alpha: 0),
                                    Colors.blue.withValues(alpha: 0.5),
                                    Colors.blue.withValues(alpha: 0),
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),

                            Expanded(
                              child: _buildCompactStatItem(
                                context,
                                'Funds',
                                widget.totalFunds,
                                Icons.arrow_downward,
                                Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: amount),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(value),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      // maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
