import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_event.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_bloc.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_event.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_state.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/expense.dart';
import 'widgets/category_selector.dart';
import 'widgets/date_picker_widget.dart';
import 'widgets/member_selection_widget.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddExpensePage({super.key, this.expense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = AppConstants.expenseCategories.first;
  List<String> _selectedMembers = [];

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final expense = widget.expense!;
    _titleController.text = expense.title;
    _descriptionController.text = expense.description;
    _amountController.text = expense.amount.toString();
    _selectedDate = expense.date;
    _selectedTime = TimeOfDay.fromDateTime(expense.date);
    _selectedCategory = expense.category;
    _selectedMembers = List.from(expense.involvedMembers);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expense' : 'Add Expense'),
        actions: [
          TextButton(
            onPressed: _saveExpense,
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                hintText: 'Enter expense title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter expense title';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Amount Field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixIcon: Icon(Icons.money_rounded),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description (optional)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Category Selector
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),

            const SizedBox(height: 16),

            // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DatePickerWidget(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      child: Text(
                        _selectedTime.format(context),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Member Selection
            BlocBuilder<MemberBloc, MemberState>(
              builder: (context, state) {
                if (state is MemberLoaded) {
                  return MemberSelectionWidget(
                    members: state.members,
                    selectedMembers: _selectedMembers,
                    onSelectionChanged: (selectedMembers) {
                      setState(() {
                        _selectedMembers = selectedMembers;
                      });
                    },
                  );
                }
                return const Center(child: Text('Loading members...'));
              },
            ),

            const SizedBox(height: 32),
            Spacer(),
            // Save Button
            ElevatedButton(
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'Update Expense' : 'Add Expense',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one member')),
      );
      return;
    }
    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final expense = Expense(
      id: _isEditing ? widget.expense!.id : const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      date: combinedDateTime,
      createdBy: _selectedMembers.first, // For now, use first selected member
      createdAt: _isEditing ? widget.expense!.createdAt : DateTime.now(),
      involvedMembers: _selectedMembers,
    );

    if (_isEditing) {
      context.read<ExpenseBloc>().add(UpdateExpense(expense, _selectedMembers));
    } else {
      context.read<ExpenseBloc>().add(AddExpense(expense, _selectedMembers));
    }
    context.read<ExpenseBloc>().add(LoadExpenses());
    context.read<DashboardBloc>().add(LoadDashboardData());

    Navigator.of(context).pop();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer, // Change this to your desired color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
