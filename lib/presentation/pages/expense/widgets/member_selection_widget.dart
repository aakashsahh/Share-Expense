import 'package:flutter/material.dart';

import '../../../../data/models/member.dart';

class MemberSelectionWidget extends StatelessWidget {
  final List<Member> members;
  final List<String> selectedMembers;
  final Function(List<String>) onSelectionChanged;

  const MemberSelectionWidget({
    super.key,
    required this.members,
    required this.selectedMembers,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.person_add,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No members found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Add members first to create expenses',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => onSelectionChanged([]),
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () =>
                      onSelectionChanged(members.map((m) => m.id).toList()),
                  child: const Text('Select All'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: members.map((member) {
              final isSelected = selectedMembers.contains(member.id);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  List<String> newSelection = List.from(selectedMembers);
                  if (value == true) {
                    newSelection.add(member.id);
                  } else {
                    newSelection.remove(member.id);
                  }
                  onSelectionChanged(newSelection);
                },

                title: Text(member.name),
                subtitle: member.phone != null ? Text(member.phone!) : null,
                secondary: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (selectedMembers.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Amount will be split equally among ${selectedMembers.length} member${selectedMembers.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
