import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_expenses/data/repositories/dashboard_repository.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final data = await repository.getDashboardData();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final data = await repository.getDashboardData();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError('Failed to refresh dashboard data: ${e.toString()}'));
    }
  }
}
