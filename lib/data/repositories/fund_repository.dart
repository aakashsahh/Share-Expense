import '../datasources/local/fund_local_datasource.dart';
import '../models/fund.dart';

abstract class FundRepository {
  Future<List<Fund>> getAllFunds();
  Future<Fund?> getFundById(String id);
  Future<void> addFund(Fund fund);
  Future<void> updateFund(Fund fund);
  Future<void> deleteFund(String id);
  Future<List<Fund>> getFundsByMember(String memberId);
}

class FundRepositoryImpl implements FundRepository {
  final FundLocalDataSource localDataSource;

  FundRepositoryImpl(this.localDataSource);

  @override
  Future<List<Fund>> getAllFunds() async {
    return await localDataSource.getAllFunds();
  }

  @override
  Future<Fund?> getFundById(String id) async {
    return await localDataSource.getFundById(id);
  }

  @override
  Future<void> addFund(Fund fund) async {
    await localDataSource.addFund(fund);
  }

  @override
  Future<void> updateFund(Fund fund) async {
    await localDataSource.updateFund(fund);
  }

  @override
  Future<void> deleteFund(String id) async {
    await localDataSource.deleteFund(id);
  }

  @override
  Future<List<Fund>> getFundsByMember(String memberId) async {
    return await localDataSource.getFundsByMember(memberId);
  }
}
