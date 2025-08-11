import 'package:equatable/equatable.dart';
import 'package:share_expenses/data/models/fund.dart';

abstract class FundEvent extends Equatable {
  const FundEvent();

  @override
  List<Object> get props => [];
}

class LoadFunds extends FundEvent {}

class AddFund extends FundEvent {
  final Fund fund;

  const AddFund(this.fund);

  @override
  List<Object> get props => [fund];
}

class UpdateFund extends FundEvent {
  final Fund fund;

  const UpdateFund(this.fund);

  @override
  List<Object> get props => [fund];
}

class DeleteFund extends FundEvent {
  final String fundId;

  const DeleteFund(this.fundId);

  @override
  List<Object> get props => [fundId];
}
