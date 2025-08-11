import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/repositories/fund_repository.dart';

import 'fund_event.dart';
import 'fund_state.dart';

class FundBloc extends Bloc<FundEvent, FundState> {
  final FundRepository repository;

  FundBloc(this.repository) : super(FundInitial()) {
    on<LoadFunds>(_onLoadFunds);
    on<AddFund>(_onAddFund);
    on<UpdateFund>(_onUpdateFund);
    on<DeleteFund>(_onDeleteFund);
  }

  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundState> emit) async {
    emit(FundLoading());
    try {
      final funds = await repository.getAllFunds();
      emit(FundLoaded(funds));
    } catch (e) {
      emit(FundError('Failed to load funds: ${e.toString()}'));
    }
  }

  Future<void> _onAddFund(AddFund event, Emitter<FundState> emit) async {
    try {
      await repository.addFund(event.fund);
      emit(const FundOperationSuccess('Fund added successfully'));
      add(LoadFunds());
    } catch (e) {
      emit(FundError('Failed to add fund: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateFund(UpdateFund event, Emitter<FundState> emit) async {
    try {
      await repository.updateFund(event.fund);
      emit(const FundOperationSuccess('Fund updated successfully'));
      add(LoadFunds());
    } catch (e) {
      emit(FundError('Failed to update fund: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteFund(DeleteFund event, Emitter<FundState> emit) async {
    try {
      await repository.deleteFund(event.fundId);
      emit(const FundOperationSuccess('Fund deleted successfully'));
      add(LoadFunds());
    } catch (e) {
      emit(FundError('Failed to delete fund: ${e.toString()}'));
    }
  }
}
