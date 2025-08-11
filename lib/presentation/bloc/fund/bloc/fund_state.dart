import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/fund.dart';

abstract class FundState extends Equatable {
  const FundState();

  @override
  List<Object> get props => [];
}

class FundInitial extends FundState {}

class FundLoading extends FundState {}

class FundLoaded extends FundState {
  final List<Fund> funds;

  const FundLoaded(this.funds);

  @override
  List<Object> get props => [funds];
}

class FundError extends FundState {
  final String message;

  const FundError(this.message);

  @override
  List<Object> get props => [message];
}

class FundOperationSuccess extends FundState {
  final String message;

  const FundOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
