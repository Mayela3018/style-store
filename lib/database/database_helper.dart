import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prenda.dart';

class DatabaseHelper {
  // Singleton: una sola instancia en toda la app
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('style_store.db');
    return _database!;
  }

  // ← EL PROFE VA A PREGUNTAR ESTO:
  // Nombre del archivo: style_store.db
  // Se guarda en el almacenamiento interno del celular
  // Versión de la base de datos: version: 1
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // ruta interna del dispositivo
    final path = join(dbPath, filePath);     // /data/data/com.example.style_store/databases/style_store.db

    return await openDatabase(
      path,
      version: 1,           // ← versión de la BD
      onCreate: _createDB,  // ← crea la tabla si no existe
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prendas (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre    TEXT NOT NULL,
        categoria TEXT NOT NULL,
        talla     TEXT NOT NULL,
        precio    REAL NOT NULL,
        stock     INTEGER NOT NULL,
        color     TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertPrenda(Prenda prenda) async {
    final db = await database;
    return await db.insert('prendas', prenda.toMap());
  }

  // READ - todas
  Future<List<Prenda>> getAllPrendas() async {
    final db = await database;
    final maps = await db.query('prendas', orderBy: 'id DESC');
    return maps.map((map) => Prenda.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updatePrenda(Prenda prenda) async {
    final db = await database;
    return await db.update(
      'prendas',
      prenda.toMap(),
      where: 'id = ?',
      whereArgs: [prenda.id],
    );
  }

  // DELETE
  Future<int> deletePrenda(int id) async {
    final db = await database;
    return await db.delete(
      'prendas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}