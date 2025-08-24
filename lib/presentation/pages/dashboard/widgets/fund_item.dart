import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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
      padding: const EdgeInsets.only(bottom: 10),
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
          elevation: 2,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            //side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onDelete,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Top row: Member Name (Expanded) + Amount (FittedBox to avoid overflow)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with subtle border
                      _MemberAvatar(memberId: fund.memberId),
                      const SizedBox(width: 12),
                      // Member name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MemberName(
                              memberId: fund.memberId,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            fund.title.isNotEmpty
                                ? Text(
                                    fund.title,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Amount (kept compact, right aligned)
                      Expanded(
                        child: Text(
                          CurrencyFormatter.format(fund.amount),
                          // maxLines: 2,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //const SizedBox(width: 8),
                      // Amount (kept compact, right aligned)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppDateUtils.getRelativeTime(fund.date),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' • ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //const SizedBox(width: 4),
                            Text(
                              DateFormat.jm().format(fund.date),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (fund.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      fund.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String memberId;

  const _MemberAvatar({required this.memberId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MemberBloc, MemberState>(
      buildWhen: (prev, curr) => curr is MemberLoaded || curr is MemberLoading,
      builder: (context, state) {
        Member? member;
        if (state is MemberLoaded) {
          member = state.members.firstWhere(
            (m) => m.id == memberId,
            orElse: () =>
                Member(id: '', name: 'Unknown', createdAt: DateTime.now()),
          );
        }

        ImageProvider? provider;
        final imagePath = member?.imagePath;
        if (imagePath != null && imagePath.isNotEmpty) {
          // decide between file path vs asset path
          if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
            provider = FileImage(File(imagePath.replaceFirst('file://', '')));
          } else {
            provider = AssetImage(imagePath);
          }
        }

        final initials = (member?.name.isNotEmpty ?? false)
            ? member!.name.trim().substring(0, 1).toUpperCase()
            : ' ';

        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.tertiary, width: 1.2),
          ),
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            backgroundImage: provider,
            child: provider == null
                ? Text(
                    initials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

/// Member name text fetched from MemberBloc. Keeps your existing data flow.
class _MemberName extends StatelessWidget {
  final String memberId;
  final TextStyle? style;

  const _MemberName({required this.memberId, this.style});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      buildWhen: (prev, curr) => curr is MemberLoaded || curr is MemberLoading,
      builder: (context, state) {
        if (state is MemberLoaded) {
          final member = state.members.firstWhere(
            (m) => m.id == memberId,
            orElse: () =>
                Member(id: '', name: 'Unknown', createdAt: DateTime.now()),
          );
          return Text(
            member.name,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
        return Text(
          'Member',
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
