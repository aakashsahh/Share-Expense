import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/models/category_model.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_state.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class CategorySelector extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
              onPressed: () {
                // Show category bottom sheet to select category
                setState(() {
                  _showCategoryBottomSheet(context);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.expenseCategories.map((category) {
            final isSelected = category == widget.selectedCategory;
            final categoryColor = AppColors.getCategoryColor(category);

            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => widget.onCategorySelected(category),
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

  void _showCategoryBottomSheet(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // Load categories
    context.read<CategoryBloc>().add(LoadCategories());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                          color: Colors.grey,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Grid Categories (Dynamic with Bloc)
                Expanded(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryLoaded) {
                        final categories = state.categories
                            .where((c) => c.type == "expense")
                            .toList();
                        return GridView.count(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                          children: categories
                              .map(
                                (category) => _buildCategoryGridItem(category),
                              )
                              .toList(),
                        );
                      } else if (state is CategoryError) {
                        return Center(child: Text("Error: ${state.message}"));
                      } else {
                        return const Center(child: Text("No categories found"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryGridItem(Category category) {
    return GestureDetector(
      onTap: () {
        widget.onCategorySelected(category.id);
        Navigator.pop(context);
      },
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(category.color).withValues(alpha: 0.3),
            ),
            child: Icon(
              category.icon, // IconData reconstructed from DB
              color: Color(category.color),
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
