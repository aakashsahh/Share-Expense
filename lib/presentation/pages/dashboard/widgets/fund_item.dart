import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_state.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/models/fund.dart';
import '../../../../data/models/member.dart';

class FundItem extends StatelessWidget {
  final Fund fund;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const FundItem({
    super.key,
    required this.fund,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (onEdit != null)
              SlidableAction(
                onPressed: (_) => onEdit!(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                icon: Icons.edit,
                label: 'Edit',
              ),
            if (onDelete != null)
              SlidableAction(
                onPressed: (_) => onDelete!(),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                icon: Icons.delete,
                label: 'Delete',
              ),
          ],
        ),
        child: Card(
          elevation: 1,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Fund Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: theme.colorScheme.tertiary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Fund Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fund.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (fund.description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            fund.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            BlocBuilder<MemberBloc, MemberState>(
                              builder: (context, state) {
                                if (state is MemberLoaded) {
                                  final member = state.members.firstWhere(
                                    (m) => m.id == fund.memberId,
                                    orElse: () => Member(
                                      id: '',
                                      name: 'Unknown',
                                      createdAt: DateTime.now(),
                                    ),
                                  );
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.tertiaryContainer
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      member.name,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onTertiaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppDateUtils.getRelativeTime(fund.date),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Text(
                    CurrencyFormatter.format(fund.amount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
