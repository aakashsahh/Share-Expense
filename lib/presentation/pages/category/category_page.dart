import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_event.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_state.dart';
import 'package:share_expenses/presentation/pages/category/add_category_page.dart';
import 'package:share_expenses/presentation/widgets/common/empty_state_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;

  // final List<Category> expenseCategories = [
  //   Category(
  //     'Others',
  //     Icons.more_horiz,
  //     Colors.grey.shade600,
  //     Colors.grey.shade200,
  //   ),
  //   Category(
  //     'Food and Dining',
  //     Icons.restaurant,
  //     Colors.orange,
  //     Colors.orange.shade100,
  //   ),
  //   Category(
  //     'Shopping',
  //     Icons.shopping_cart,
  //     Colors.blue,
  //     Colors.blue.shade100,
  //   ),
  //   Category(
  //     'Travelling',
  //     Icons.alt_route,
  //     Colors.purple,
  //     Colors.purple.shade100,
  //   ),
  //   Category('Balance', Icons.smartphone, Colors.green, Colors.green.shade100),
  //   Category('Medical', Icons.favorite, Colors.red, Colors.red.shade100),
  //   Category(
  //     'Personal Care',
  //     Icons.bathtub,
  //     Colors.orange.shade700,
  //     Colors.orange.shade100,
  //   ),
  //   Category(
  //     'Education',
  //     Icons.school,
  //     Colors.purple.shade700,
  //     Colors.purple.shade100,
  //   ),
  //   Category(
  //     'Entertainment',
  //     Icons.movie,
  //     Colors.blue.shade700,
  //     Colors.blue.shade100,
  //   ),
  //   Category(
  //     'Bills',
  //     Icons.receipt,
  //     Colors.teal.shade700,
  //     Colors.teal.shade100,
  //   ),
  //   Category(
  //     'Transportation',
  //     Icons.directions_car,
  //     Colors.brown.shade700,
  //     Colors.brown.shade100,
  //   ),
  // ];

  // final List<Category> incomeCategories = [
  //   Category(
  //     'Salary',
  //     Icons.monetization_on,
  //     Colors.green,
  //     Colors.green.shade100,
  //   ),
  //   Category('Bonus', Icons.card_giftcard, Colors.teal, Colors.teal.shade100),
  //   Category(
  //     'Investments',
  //     Icons.show_chart,
  //     Colors.deepPurple,
  //     Colors.deepPurple.shade100,
  //   ),
  //   Category(
  //     'Freelance',
  //     Icons.work_outline,
  //     Colors.brown,
  //     Colors.brown.shade100,
  //   ),
  // ];
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    // final selectedCategories = isExpense ? expenseCategories : incomeCategories;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const SizedBox(height: 8),
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
              const SizedBox(height: 34),
              // Text(
              //   isExpense ? "Expense Categories" : "Income Categories",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: isExpense ? Colors.black87 : Colors.green.shade700,
              //     fontSize: 17,
              //   ),
              // ),
              // const SizedBox(height: 20),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return CircularProgressIndicator();
                  } else if (state is CategoryLoaded) {
                    final categories = state.categories
                        .where((c) => c.type == "expense")
                        .toList();
                    return Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.4,
                            ),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          //selectedCategories[index];
                          var theme = Theme.of(context);
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddCategoryPage(category: category),
                                ),
                              );
                              // Add your onTap logic here
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                //border: Border.all(color: category.bgColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Color(
                                      category.color,
                                    ).withValues(alpha: 0.2),
                                    child: Icon(
                                      category.icon,
                                      color: Color(category.color),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    category.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: colorScheme.onSurface),

                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CategoryError) {
                    return EmptyStateWidget(
                      icon: Icons.error,
                      title: state.message,
                      subtitle: '',
                    );
                  } else {
                    return EmptyStateWidget(
                      icon: Icons.error,
                      title: 'Something went wrong',
                      subtitle: '',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddCategoryPage()),
          );
        },
        child: Icon(
          Icons.category,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  Category(this.name, this.icon, this.iconColor, this.bgColor);
}
