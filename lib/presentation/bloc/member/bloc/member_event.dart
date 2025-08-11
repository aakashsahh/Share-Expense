import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/member.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class LoadMembers extends MemberEvent {}

class AddMember extends MemberEvent {
  final Member member;

  const AddMember(this.member);

  @override
  List<Object> get props => [member];
}

class UpdateMember extends MemberEvent {
  final Member member;

  const UpdateMember(this.member);

  @override
  List<Object> get props => [member];
}

class DeleteMember extends MemberEvent {
  final String memberId;

  const DeleteMember(this.memberId);

  @override
  List<Object> get props => [memberId];
}
