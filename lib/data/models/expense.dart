import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;
  final List<String> involvedMembers;

  const Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.involvedMembers,
  });

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    String? createdBy,
    DateTime? createdAt,
    List<String>? involvedMembers,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      involvedMembers: involvedMembers ?? this.involvedMembers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'created_by': createdBy,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: json['amount']?.toDouble() ?? 0.0,
      category: json['category'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      createdBy: json['created_by'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      involvedMembers: [], // This will be loaded separately
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    category,
    date,
    createdBy,
    createdAt,
    involvedMembers,
  ];
}
