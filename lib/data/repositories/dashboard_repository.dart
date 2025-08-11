import '../datasources/local/dashboard_local_datasource.dart';
import '../models/dashboard_data.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl(this.localDataSource);

  @override
  Future<DashboardData> getDashboardData() async {
    return await localDataSource.getDashboardData();
  }
}
