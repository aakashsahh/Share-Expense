import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/models/category_model.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/pages/category/category_page.dart'
    as pages;

class CategorySelector extends StatefulWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category) onCategorySelected;
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedCategory;
    if (selected == null) return SizedBox.shrink();
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
        InkWell(
          onTap: () {
            _showCategoryBottomSheet(context);
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(selected.color).withValues(alpha: 0.2),

                  shape: BoxShape.circle,
                ),
                child: Icon(selected.icon, color: Color(selected.color)),
              ),
              SizedBox(width: 8),
              Text(selected.name, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        // Wrap(
        //   spacing: 8,
        //   runSpacing: 8,
        //   children: widget.categories.map((category) {
        //     final isSelected = widget.selectedCategory?.id == category.id;
        //     final color = Color(category.color);

        //     return FilterChip(
        //       label: Text(category.name),
        //       selected: isSelected,
        //       onSelected: (_) => widget.onCategorySelected(category),
        //       backgroundColor: color.withOpacity(0.1),
        //       selectedColor: color.withOpacity(0.2),
        //       checkmarkColor: color,
        //       labelStyle: TextStyle(
        //         color: isSelected ? color : null,
        //         fontWeight: isSelected ? FontWeight.w600 : null,
        //       ),
        //     );
        //   }).toList(),
        // ),
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
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => pages.CategoryPage(),
                              ),
                            );
                          },
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                          mainAxisExtent:
                              100, // 👈 enough height for icon + 2 lines
                        ),
                    itemCount: widget.categories.length,
                    itemBuilder: (_, i) =>
                        _buildCategoryGridItem(widget.categories[i]),
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
      onTap: () => widget.onCategorySelected(category),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(category.color).withValues(alpha: 0.3),
                ),
                child: Icon(
                  category.icon,
                  color: Color(category.color),
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: constraints.maxWidth, // 👈 use full cell width
                height: 34, // 👈 ~2 lines at 12sp (stable)
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(fontSize: 12, height: 1.2),
                  // Optional for perfectly consistent line height:
                  strutStyle: const StrutStyle(
                    fontSize: 12,
                    height: 1.2,
                    forceStrutHeight: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
