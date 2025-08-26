// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/models/category_model.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/pages/category/widgets/color_selector_widget.dart';
import 'package:share_expenses/presentation/pages/category/widgets/icon_selector.dart';

class AddCategoryPage extends StatefulWidget {
  final Category? category;
  const AddCategoryPage({super.key, this.category});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isExpense = true;
  late Color _selectedColor;
  IconData? _selectedIcon;
  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    } else {
      isExpense = true;
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.more_horiz_outlined;
    }
  }

  void _populateFields() {
    // prefill fields for editing
    categoryNameController.text = widget.category!.name;
    isExpense = widget.category!.type == "expense";
    _selectedColor = Color(widget.category!.color);
    _selectedIcon = widget.category!.icon;
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    final category = Category(
      id: widget.category?.id ?? '', // empty → will be generated in local DS
      name: categoryNameController.text.trim(),
      iconCodePoint: (_selectedIcon ?? Icons.category).codePoint,
      iconFontFamily:
          (_selectedIcon ?? Icons.category).fontFamily ?? 'MaterialIcons',
      type: isExpense ? "expense" : "fund",
      color: _selectedColor.value,
    );

    if (_isEditing) {
      context.read<CategoryBloc>().add(UpdateCategory(category));
    } else {
      context.read<CategoryBloc>().add(AddCategory(category));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Category" : "Add Category"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: _saveCategory,
            //_saveExpense,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      //appBar: CustomAppBar(title: 'Add Category'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           if (!isExpense) {
                //             setState(() {
                //               isExpense = true;
                //             });
                //           }
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(vertical: 10),
                //           decoration: BoxDecoration(
                //             color: isExpense ? colorScheme.error : Colors.white,
                //             borderRadius: BorderRadius.circular(18),
                //             border: Border.all(
                //               color: isExpense
                //                   ? colorScheme.error.withValues(alpha: 0.8)
                //                   : Colors.grey.shade300,
                //               width: 1.2,
                //             ),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 Icons.arrow_downward,
                //                 color: isExpense ? Colors.white : Colors.black87,
                //                 size: 18,
                //               ),
                //               const SizedBox(width: 6),
                //               Text(
                //                 'Expense',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w600,
                //                   color: isExpense
                //                       ? Colors.white
                //                       : Colors.black87,
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           if (isExpense) {
                //             setState(() {
                //               isExpense = false;
                //             });
                //           }
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(vertical: 10),
                //           decoration: BoxDecoration(
                //             color: !isExpense ? Colors.green : Colors.white,
                //             borderRadius: BorderRadius.circular(18),
                //             border: Border.all(
                //               color: !isExpense
                //                   ? Colors.green
                //                   : Colors.grey.shade300,
                //               width: 1.2,
                //             ),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 Icons.arrow_upward,
                //                 color: !isExpense ? Colors.white : Colors.black87,
                //                 size: 18,
                //               ),
                //               const SizedBox(width: 6),
                //               Text(
                //                 'Income',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w600,
                //                   color: !isExpense
                //                       ? Colors.white
                //                       : Colors.black87,
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //const SizedBox(height: 34),
                // CustomTextField(
                //   controller: categoryNameController,
                //   hintText: 'Enter category name',
                //   isNumber: true,
                //   validator: (value) {
                //     if (value == null || value.trim().isEmpty) {
                //       return 'Please enter an category name';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter category title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 34),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,

                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedIcon ?? Icons.credit_card_rounded,
                        size: 32,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        final IconData? selectedIcon =
                            await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IconSelectorPage(
                                      initialSelectedIcon: _selectedIcon,
                                    ),
                                  ),
                                )
                                as IconData?;

                        if (selectedIcon != null) {
                          setState(() {
                            _selectedIcon = selectedIcon;
                          });
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Category Icon',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Tap to select an icon',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Text(
                  'Category Colors',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                ColorSelectorWidget(
                  key: UniqueKey(), // reset state if editing
                  onColorSelected: (color) {
                    _selectedColor = color;
                  },
                ),
                //  Spacer(),
                // TextButton(
                //   onPressed: () {},
                //   //_saveExpense,
                //   child: Text(
                //     'Save',
                //     // _isEditing ? 'Update' : 'Save',
                //     style: TextStyle(
                //       color: Theme.of(context).colorScheme.primary,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      //bottomNavigationBar: CustomSaveButton(label: 'Save Category'),
    );
  }
}
