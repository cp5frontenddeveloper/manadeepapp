import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

    Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        note TEXT
      )
    '''); // Removed extra comma
  }

  // Add error handling
  Future<int> insertNote(String note) async {
    try {
      final db = await database;
      return await db.insert('notes', {'note': note});
    } catch (e) {
      print('Error inserting note: $e');
      return -1;
    }
  }

  // Get all notes
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  // Update note
  Future<int> updateNote(int id, String newNote) async {
    final db = await database;
    return await db.update(
      'notes',
      {'note': newNote},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Delete note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}