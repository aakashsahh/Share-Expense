import 'package:get_it/get_it.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:share_expenses/data/datasources/local/expense_local_datasource.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_bloc.dart';
import 'package:share_expenses/presentation/bloc/fund/bloc/fund_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local/dashboard_local_datasource.dart';
import 'data/datasources/local/fund_local_datasource.dart';
import 'data/datasources/local/member_local_datasource.dart';
import 'data/datasources/preferences/app_preferences.dart';
import 'data/repositories/dashboard_repository.dart';
import 'data/repositories/expense_repository.dart';
import 'data/repositories/fund_repository.dart';
import 'data/repositories/member_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton(() => DatabaseHelper());

  // Data sources
  sl.registerLazySingleton<AppPreferences>(() => AppPreferencesImpl(sl()));
  sl.registerLazySingleton<MemberLocalDataSource>(
    () => MemberLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FundLocalDataSource>(
    () => FundLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<MemberRepository>(() => MemberRepositoryImpl(sl()));
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FundRepository>(() => FundRepositoryImpl(sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // Blocs
  sl.registerFactory(() => MemberBloc(sl()));
  sl.registerFactory(() => ExpenseBloc(sl()));
  sl.registerFactory(() => FundBloc(sl()));
  sl.registerFactory(() => DashboardBloc(sl()));
}
