import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.expenseCategories.map((category) {
            final isSelected = category == selectedCategory;
            final categoryColor = AppColors.getCategoryColor(category);

            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              backgroundColor: categoryColor.withValues(alpha: 0.1),
              selectedColor: categoryColor.withValues(alpha: 0.2),
              checkmarkColor: categoryColor,
              labelStyle: TextStyle(
                color: isSelected ? categoryColor : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
