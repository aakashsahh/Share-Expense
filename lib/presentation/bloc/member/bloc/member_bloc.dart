import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/repositories/member_repository.dart';

import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository repository;

  MemberBloc(this.repository) : super(MemberInitial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMember>(_onAddMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
  }

  Future<void> _onLoadMembers(
    LoadMembers event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());
    try {
      final members = await repository.getAllMembers();
      emit(MemberLoaded(members));
    } catch (e) {
      emit(MemberError('Failed to load members: ${e.toString()}'));
    }
  }

  Future<void> _onAddMember(AddMember event, Emitter<MemberState> emit) async {
    try {
      await repository.addMember(event.member);
      emit(const MemberOperationSuccess('Member added successfully'));
      add(LoadMembers());
    } catch (e) {
      emit(MemberError('Failed to add member: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMember(
    UpdateMember event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.updateMember(event.member);
      emit(const MemberOperationSuccess('Member updated successfully'));
      add(LoadMembers());
    } catch (e) {
      emit(MemberError('Failed to update member: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMember(
    DeleteMember event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.deleteMember(event.memberId);
      emit(const MemberOperationSuccess('Member deleted successfully'));
      add(LoadMembers());
    } catch (e) {
      emit(MemberError('Failed to delete member: ${e.toString()}'));
    }
  }
}
