import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/lokasi_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static const _dbName = 'destinasi.db';
  static const _dbVersion = 1;
  static const tableName = 'destinasi';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // debug: print path database ke console
    print('DATABASE PATH: $path');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // types: REAL for double, TEXT for string
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        deskripsi TEXT,
        alamat TEXT,
        foto TEXT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        tanggal TEXT,
        jam_buka TEXT,
        jam_tutup TEXT
      )
    ''');
    print('TABLE $tableName CREATED');
  }

  // create insert
  Future<int> create(LokasiModel data) async {
    final db = await database;
    final id = await db.insert(tableName, data.toMap());
    return id;
  }

  // read all
  Future<List<LokasiModel>> readAll() async {
    final db = await database;
    final maps = await db.query(tableName, orderBy: 'id DESC');
    return maps.map((m) => LokasiModel.fromMap(m)).toList();
  }

  // read single (optional)
  Future<LokasiModel?> readOne(int id) async {
    final db = await database;
    final maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) return LokasiModel.fromMap(maps.first);
    return null;
  }

  // update
  Future<int> update(LokasiModel data) async {
    final db = await database;
    if (data.id == null) throw Exception('ID is null on update');
    return await db
        .update(tableName, data.toMap(), where: 'id = ?', whereArgs: [data.id]);
  }

  // delete
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // close DB (optional)
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
