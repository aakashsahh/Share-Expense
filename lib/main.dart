import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_expenses/presentation/bloc/category/bloc/category_bloc.dart';
import 'package:share_expenses/presentation/bloc/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_expenses/presentation/bloc/expense/bloc/expense_bloc.dart';
import 'package:share_expenses/presentation/bloc/fund/bloc/fund_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';

import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/dashboard/dashboard_page.dart';

late Directory appDocDir;

Future<void> loadDirectory() async {
  appDocDir = await getApplicationDocumentsDirectory();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await loadDirectory();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ExpenseSharingApp());
  });
}

class ExpenseSharingApp extends StatelessWidget {
  const ExpenseSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider(create: (_) => di.sl<MemberBloc>()),
        BlocProvider(create: (_) => di.sl<ExpenseBloc>()),
        BlocProvider(create: (_) => di.sl<FundBloc>()),
        BlocProvider(create: (_) => di.sl<CategoryBloc>()),
      ],
      child: MaterialApp(
        title: 'Expense Sharing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.light,
        home: DashboardPage(),
      ),
    );
  }
}
