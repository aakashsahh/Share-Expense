class AppConstants {
  static const String appName = 'Expense Sharing';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'expense_sharing.db';
  static const int databaseVersion = 1;

  // Table names
  static const String membersTable = 'members';
  static const String expensesTable = 'expenses';
  static const String fundsTable = 'funds';
  static const String expenseMembersTable = 'expense_members';

  // Categories
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Entertainment',
    'Shopping',
    'Bills',
    'Others',
  ];

  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Shared preferences keys
  static const String firstTimeKey = 'first_time';
  static const String themeKey = 'theme_mode';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
}
