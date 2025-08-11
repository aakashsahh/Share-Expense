import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/member.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<Member> members;

  const MemberLoaded(this.members);

  @override
  List<Object> get props => [members];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object> get props => [message];
}

class MemberOperationSuccess extends MemberState {
  final String message;

  const MemberOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
