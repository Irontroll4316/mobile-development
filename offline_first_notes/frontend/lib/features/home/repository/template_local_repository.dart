import 'package:offline_first_notes/models/template_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TemplateLocalRepository {
  String tableName = "templates";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "templates.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE $tableName(
        name TEXT PRIMARY KEY,
        uid TEXT NOT NULL REFERENCES users(id),
        createdAt TEXT NOT NULL,
        lastUsed TEXT NOT NULL,
        color TEXT NOT NULL,
        isSynced INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  Future<void> insertTemplate(TemplateModel template) async {
    final db = await database;
    await db.delete(tableName, where: 'name = ?', whereArgs: [template.name]);
    await db.insert(tableName, template.toMap());
  }

  Future<void> insertTemplates(List<TemplateModel> templates) async {
    final db = await database;
    final batch = db.batch();
    for (final template in templates) {
      batch.insert(
        tableName,
        template.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<TemplateModel>> getTemplates() async {
    print(":(");
    final db = await database;
    final result = await db.query(tableName);
    if (result.isNotEmpty) {
      List<TemplateModel> templates = [];
      for (final element in result) {
        templates.add(TemplateModel.fromMap(element));
      }
      return templates;
    }
    return [];
  }

  Future<List<TemplateModel>> getUnsycnedTemplates() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<TemplateModel> templates = [];
      for (final element in result) {
        templates.add(TemplateModel.fromMap(element));
      }
      return templates;
    }
    return [];
  }

  Future<void> updateisSynced(String name, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> updateLastUsed(String name) async {
    final db = await database;
    await db.update(
      tableName,
      {'lastUsed': DateTime.now()},
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
