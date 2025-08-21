import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/category_model.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;
  final Category? category; // optional, loaded when joined
  final List<String> involvedMembers;

  const Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.category,
    required this.involvedMembers,
  });

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? createdBy,
    DateTime? createdAt,
    Category? category,
    List<String>? involvedMembers,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      involvedMembers: involvedMembers ?? this.involvedMembers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category_id': category!.id,
      'date': date.millisecondsSinceEpoch,
      'created_by': createdBy,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json, {Category? category}) {
    return Expense(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: json['amount'],
      categoryId: json['category_id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      createdBy: json['created_by'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      category: category,
      involvedMembers: [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    categoryId,
    date,
    createdBy,
    createdAt,
    category,
    involvedMembers,
  ];
}
