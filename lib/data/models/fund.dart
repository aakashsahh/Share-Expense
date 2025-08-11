import 'package:equatable/equatable.dart';

class Fund extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String memberId;
  final DateTime date;
  final DateTime createdAt;

  const Fund({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.memberId,
    required this.date,
    required this.createdAt,
  });

  Fund copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? memberId,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Fund(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'member_id': memberId,
      'date': date.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: json['amount']?.toDouble() ?? 0.0,
      memberId: json['member_id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    memberId,
    date,
    createdAt,
  ];
}
