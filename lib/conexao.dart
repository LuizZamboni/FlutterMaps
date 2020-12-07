
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class latitudeLong {
  int id;
  String latitude;
  String longitude;
  String nome;

  latitudeLong(this.id, this.latitude, this.longitude, this.nome);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'nome': nome,
    };
    return map;
  }

  latitudeLong.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    nome = map['nome'];
  }
}

class Conn {
  static Conn _conn;
  static Database _database;

  Conn._createInstance();

  String latitudeLongTable = 'latitudeLongTable';
  String colId = 'id';
  String colLatitude = 'latitude';
  String colLongitude = 'longitude';
  String colNome = 'nome';

  factory Conn() {
    if (_conn == null) {
      _conn = Conn._createInstance();
    }
    return _conn;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'zamboni.db';
    var userDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $latitudeLongTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colLatitude TEXT, $colLongitude TEXT, $colNome TEXT)');
  }

  Future<int> insertLatitudeLong(latitudeLong latitudeLong) async {
    Database db = await this.database;

    var resultado = await db.insert(latitudeLongTable, latitudeLong.toMap());

    return resultado;
  }

  Future deleteAll() async {
    var db = await this.database;

    var resultado = await db.delete(latitudeLongTable);

    return resultado;
  }

  Future<latitudeLong> getLongitudeLong(int id) async {
    Database db = await this.database;

    List<Map> maps = await db.query(latitudeLongTable,
        columns: [
          colId,
          colLatitude,
          colLongitude,
          colNome,
        ],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return latitudeLong.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRecente(int id) async {
    var db = await this.database;

    int resultado =
    await db.delete(latitudeLongTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $latitudeLongTable');

    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  Future<List<latitudeLong>> getLatitudeLong() async {
    Database db = await this.database;

    var resultado = await db.query(latitudeLongTable);

    List<latitudeLong> lista = resultado.isNotEmpty
        ? resultado.map((c) => latitudeLong.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
