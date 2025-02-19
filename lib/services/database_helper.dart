import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('income_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE income_sources(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // Helper methods for CRUD operations
  Future<int> insertIncomeSource(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('income_sources', row);
  }

  Future<List<Map<String, dynamic>>> getAllIncomeSources() async {
    final db = await database;
    return await db.query('income_sources');
  }

  Future<Map<String, dynamic>?> getIncomeSourceById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'income_sources',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateIncomeSource(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'income_sources',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteIncomeSource(int id) async {
    final db = await database;
    return await db.delete(
      'income_sources',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
