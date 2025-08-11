import 'package:equatable/equatable.dart';

class ExpenseMember extends Equatable {
  final String id;
  final String expenseId;
  final String memberId;
  final double amountOwed;

  const ExpenseMember({
    required this.id,
    required this.expenseId,
    required this.memberId,
    required this.amountOwed,
  });

  ExpenseMember copyWith({
    String? id,
    String? expenseId,
    String? memberId,
    double? amountOwed,
  }) {
    return ExpenseMember(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      amountOwed: amountOwed ?? this.amountOwed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense_id': expenseId,
      'member_id': memberId,
      'amount_owed': amountOwed,
    };
  }

  factory ExpenseMember.fromJson(Map<String, dynamic> json) {
    return ExpenseMember(
      id: json['id'],
      expenseId: json['expense_id'],
      memberId: json['member_id'],
      amountOwed: json['amount_owed']?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, expenseId, memberId, amountOwed];
}
