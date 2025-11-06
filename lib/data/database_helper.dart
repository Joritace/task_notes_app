import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            priority TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTask(TaskItem task) async {
    Database db = await database;
    return await db.insert('tasks', task.toJson());
  }

  Future<List<TaskItem>> getTasks() async {
    Database db = await database;
    final data = await db.query('tasks');
    return data.map((e) => TaskItem.fromJson(e)).toList();
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
