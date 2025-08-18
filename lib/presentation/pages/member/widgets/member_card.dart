import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_expenses/core/utils/currency_formatter.dart';
import 'package:share_expenses/data/models/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final double balance;
  final double funds;
  final double expenses;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MemberCard({
    super.key,
    required this.member,
    required this.balance,
    required this.funds,
    required this.expenses,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = balance >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: Avatar + Name + Phone
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primaryFixedDim,
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        backgroundImage: member.imagePath != null
                            ? FileImage(File(member.imagePath!))
                            : null,
                        child: member.imagePath == null
                            ? Text(
                                member.name.substring(0, 1).toUpperCase(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (member.phone != null && member.phone!.isNotEmpty)
                            Text(
                              member.phone!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Optional edit/delete actions
                    // if (onEdit != null || onDelete != null)
                    //   PopupMenuButton<String>(
                    //     onSelected: (value) {
                    //       if (value == 'edit') onEdit?.call();
                    //       if (value == 'delete') onDelete?.call();
                    //     },
                    //     itemBuilder: (context) => [
                    //       if (onEdit != null)
                    //         const PopupMenuItem(
                    //           value: 'edit',
                    //           child: Text('Edit'),
                    //         ),
                    //       // if (onDelete != null)
                    //       //   const PopupMenuItem(
                    //       //     value: 'delete',
                    //       //     child: Text('Delete'),
                    //       //   ),
                    //     ],
                    //   ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Balance Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    //color: theme.colorScheme.primaryContainer,
                    color: isPositive
                        ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPositive
                          ? theme.colorScheme.tertiaryContainer
                          : theme.colorScheme.errorContainer,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Balance",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(balance),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// Funds & Expenses
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(
                        context,
                        "Funds",
                        funds,
                        theme.colorScheme.tertiary,
                      ),
                    ),
                    Container(
                      height: 40,
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
                      child: _buildStat(
                        context,
                        "Expenses",
                        expenses,
                        theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(value),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
                // fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
