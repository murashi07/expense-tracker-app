import 'package:expense_tracker_app/models/budget.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/saving_goal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "ExpenseTracker.db";
  static const _databaseVersion = 1;

  // Expense table
  static const tableExpenses = 'expenses';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnAmount = 'amount';
  static const columnDate = 'date';
  static const columnCategory = 'category';
  static const columnDescription = 'description';

  // Budget table
  static const tableBudgets = 'budgets';
  static const columnBudgetCategory = 'category';
  static const columnBudgetAmount = 'amount';
  static const columnBudgetStartDate = 'startDate';
  static const columnBudgetEndDate = 'endDate';

  // Savings Goal table
  static const tableSavingsGoals = 'saving_goals';
  static const columnGoalTitle = 'title';
  static const columnGoalTargetAmount = 'targetAmount';
  static const columnGoalCurrentAmount = 'currentAmount';
  static const columnGoalDeadline = 'deadline';
  static const columnGoalDescription = 'description';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create expenses table
    await db.execute('''
      CREATE TABLE $tableExpenses (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnDescription TEXT
      )
      ''');

    // Create budgets table
    await db.execute('''
      CREATE TABLE $tableBudgets (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnBudgetCategory TEXT NOT NULL,
        $columnBudgetAmount REAL NOT NULL,
        $columnBudgetStartDate TEXT NOT NULL,
        $columnBudgetEndDate TEXT NOT NULL
      )
      ''');

    // Create saving goals table
    await db.execute('''
      CREATE TABLE $tableSavingsGoals (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnGoalTitle TEXT NOT NULL,
        $columnGoalTargetAmount REAL NOT NULL,
        $columnGoalCurrentAmount REAL NOT NULL,
        $columnGoalDeadline TEXT NOT NULL,
        $columnGoalDescription TEXT
      )
      ''');
  }

  // --- Expenses Table Operations ---

  Future<int> insertExpense(Expense expense) async {
    Database db = await instance.database;
    return await db.insert(tableExpenses, expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableExpenses);
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await instance.database;
    return await db.update(tableExpenses, expense.toMap(),
        where: '$columnId = ?', whereArgs: [expense.id]);
  }

  Future<int> deleteExpense(int id) async {
    Database db = await instance.database;
    return await db.delete(tableExpenses, where: '$columnId = ?', whereArgs: [id]);
  }

  // --- Budgets Table Operations ---

  Future<int> insertBudget(Budget budget) async {
    Database db = await instance.database;
    return await db.insert(tableBudgets, budget.toMap());
  }

  Future<List<Budget>> getBudgets() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableBudgets);
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  Future<int> updateBudget(Budget budget) async {
    Database db = await instance.database;
    return await db.update(tableBudgets, budget.toMap(),
        where: '$columnId = ?', whereArgs: [budget.id]);
  }

  Future<int> deleteBudget(int id) async {
    Database db = await instance.database;
    return await db.delete(tableBudgets, where: '$columnId = ?', whereArgs: [id]);
  }

  // --- Savings Goals Table Operations ---

  Future<int> insertSavingGoal(SavingGoal goal) async {
    Database db = await instance.database;
    return await db.insert(tableSavingsGoals, goal.toMap());
  }

  Future<List<SavingGoal>> getSavingGoals() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableSavingsGoals);
    return List.generate(maps.length, (i) {
      return SavingGoal.fromMap(maps[i]);
    });
  }

  Future<int> updateSavingGoal(SavingGoal goal) async {
    Database db = await instance.database;
    return await db.update(tableSavingsGoals, goal.toMap(),
        where: '$columnId = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteSavingGoal(int id) async {
    Database db = await instance.database;
    return await db.delete(tableSavingsGoals, where: '$columnId = ?', whereArgs: [id]);
  }
}