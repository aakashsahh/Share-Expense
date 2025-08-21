import 'package:path/path.dart';
import 'package:share_expenses/data/datasources/local/category_local_datasource.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE expenses ADD COLUMN category_id TEXT");
    }
  }

  Future<void> _createTables(Database db) async {
    // Members table
    await db.execute('''
      CREATE TABLE ${AppConstants.membersTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        image_path TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Expenses table
    await db.execute('''
  CREATE TABLE ${AppConstants.expensesTable} (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    amount REAL NOT NULL,
    category_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    created_by TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES ${AppConstants.membersTable} (id),
    FOREIGN KEY (category_id) REFERENCES ${AppConstants.categoriesTable} (id) ON DELETE CASCADE
  )
''');

    // Funds table
    await db.execute('''
      CREATE TABLE ${AppConstants.fundsTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        member_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (member_id) REFERENCES ${AppConstants.membersTable} (id)
      )
    ''');

    // Expense members junction table
    await db.execute('''
      CREATE TABLE ${AppConstants.expenseMembersTable} (
        id TEXT PRIMARY KEY,
        expense_id TEXT NOT NULL,
        member_id TEXT NOT NULL,
        amount_owed REAL NOT NULL,
        FOREIGN KEY (expense_id) REFERENCES ${AppConstants.expensesTable} (id) ON DELETE CASCADE,
        FOREIGN KEY (member_id) REFERENCES ${AppConstants.membersTable} (id)
      )
    ''');
    await db.execute('''
          CREATE TABLE ${AppConstants.categoriesTable} (
             id TEXT PRIMARY KEY,
             name TEXT,
             iconCodePoint INTEGER,
             iconFontFamily TEXT,
             type TEXT,
             color INTEGER
          )
        ''');

    // Create indexes for better performance
    await db.execute(
      'CREATE INDEX idx_expenses_date ON ${AppConstants.expensesTable} (date)',
    );
    await db.execute(
      'CREATE INDEX idx_funds_date ON ${AppConstants.fundsTable} (date)',
    );
    await db.execute(
      'CREATE INDEX idx_expense_members_expense ON ${AppConstants.expenseMembersTable} (expense_id)',
    );
    await db.execute(
      'CREATE INDEX idx_expense_members_member ON ${AppConstants.expenseMembersTable} (member_id)',
    );
  }

  Future<void> resetDatabase() async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await database;
    await db.delete(AppConstants.expenseMembersTable);
    await db.delete(AppConstants.expensesTable);
    await db.delete(AppConstants.fundsTable);
    await db.delete(AppConstants.membersTable);
    await db.delete(AppConstants.categoriesTable);
    await CategoryLocalDataSourceImpl(databaseHelper).initDefaultCategories();
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
