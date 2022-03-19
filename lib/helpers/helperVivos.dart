import 'dart:io';
import 'package:infonimalapp/models/animal.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  //definir as colunas da tabelaW
  String animaisTable = 'animais';
  String colBrinco = 'brinco';
  String colPeso = 'peso';
  String colPreco = 'preco';
  String colSexo = 'sexo';
  String colRaca = 'raca';
  String colDataNascimento = 'dataNascimento';
  String colDataAquisicao = 'dataAquisicao';
  String colOrigem = 'origem';

  static late DatabaseHelper _databaseHelper;
  static late Database _database;

  //construtor nomeado para criar instância da classe
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();

    return _database;
  }

  //criar o banco de dados localmente
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Animais.bd';

    var animaisDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return animaisDatabase;
  }

  //deleter o banco de dados
  Future<void> deleteDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Animais.bd';
    return databaseFactory.deleteDatabase(path);
  }

  //comando para criar a tabela animais
  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $animaisTable ($colBrinco INTEGER PRIMARY KEY, $colPeso REAL, $colSexo TEXT, $colPreco REAL, $colOrigem TEXT, $colRaca TEXT, $colDataNascimento TEXT, $colDataAquisicao)');
  }

  void aaa() async {
    var db = await this.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $animaisTable ($colBrinco INTEGER, $colPeso REAL, $colSexo TEXT, $colPreco REAL, $colOrigem TEXT, $colRaca TEXT, $colDataNascimento TEXT, $colDataAquisicao)');
  }

  void deleteDB() async {
    Database db = await this.database;
    db.execute("DROP TABLE $animaisTable");
    initializeDatabase();
  }

  //incluir um objeto Animal no bd
  Future<int> insertAnimal(Animal animal) async {
    Database db = await this.database;
    var resultado = await db.insert(animaisTable, animal.toMap());
    return resultado;
  }

  //atualizar o objeto animal e salvar no banco de dados
  Future<int> updateAnimal(Animal animal) async {
    var db = await this.database;

    var resultado = await db.update(animaisTable, animal.toMap(),
        where: '$colBrinco = ?', whereArgs: [animal.brinco]);

    return resultado;
  }

  //deletar um objeto animal do banco de dados
  Future<int> deleteAnimal(int brinco) async {
    var db = await this.database;

    var resultado = await db
        .delete(animaisTable, where: '$colBrinco = ?', whereArgs: [brinco]);

    return resultado;
  }

  //deletar todos os registros da tabela
  void deleteAllAnimals() async {
    Database db = await this.database;
    await db.execute('DELETE FROM $animaisTable');
  }

  Future<double?> getPeso() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT SUM($colPeso) AS total FROM $animaisTable');

    double? x = result[0]['total'] as double?;

    return x;
  }

  Future<int?> getNasc() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colOrigem) AS total FROM $animaisTable WHERE $colOrigem = ?',
        ['Reprodução']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getCompra() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colOrigem) AS total FROM $animaisTable WHERE $colOrigem = ?',
        ['Comprada']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getMachos() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colSexo) AS total FROM $animaisTable WHERE $colSexo = ?',
        ['Macho']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getFemeas() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colSexo) AS total FROM $animaisTable WHERE $colSexo = ?',
        ['Fêmea']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getDorper() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colRaca) AS total FROM $animaisTable WHERE $colRaca = ?',
        ['Dorper']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getSanta() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colRaca) AS total FROM $animaisTable WHERE $colRaca = ?',
        ['Santa Inês']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  Future<int?> getTexel() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT COUNT($colRaca) AS total FROM $animaisTable WHERE $colRaca = ?',
        ['Texel']);

    int? x = result[0]['total'] as int?;

    return x;
  }

  //retornar todos os animais
  Future<List<Animal>> getAnimais() async {
    Database db = await this.database;

    var resultado = await db.query(animaisTable, orderBy: '$colBrinco ASC');

    List<Animal> lista = resultado.isNotEmpty
        ? resultado.map((c) => Animal.fromMap(c)).toList()
        : [];
    return lista;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
