import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_exam/model/task.model.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate:(db, version) async {
        await db.execute('''
        CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INT NOT NULL
        )
        ''');
      },
    );
  }
  Future<List<Task>> getAllTasks() async{
    final db= await database;
    final maps = await db.query('tasks',orderBy: 'id DESC');
    return maps.map((m)=> Task.fromMap(m)).toList();
  }
  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }
  Future<int> updateTask(Task task) async{
    final db = await database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
  Future<int> deleteTask (int id) async {
    final db= await database;
    return db.delete('tasks',where: 'id=?',whereArgs: [id]);
  }

}