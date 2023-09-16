import 'package:imc_calculator/models/imc_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

String scriptCreateTable = ''' CREATE TABLE imc (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          height REAL,
          weight REAL,
          imcResult TEXT
          );''';

class SQFLiteDataBase {
  static Database? _db;
  static Future<Database> _getDatabase() async {
    if (_db == null) {
      return await _createDatabase();
    } else {
      return _db!;
    }
  }

  static Future<Database> _createDatabase() async {
    var db = await openDatabase(
      path.join(await getDatabasesPath(), 'imc.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(scriptCreateTable);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute(scriptCreateTable);
      },
    );
    return db;
  }

  static Future<List<ImcModel>> getImcData() async {
    List<ImcModel> imcResults = [];
    try {
      var db = await SQFLiteDataBase._getDatabase();
      var result =
          await db.rawQuery('SELECT id, name, height, weight FROM imc');
      for (var element in result) {
        imcResults.add(
          ImcModel(
            height: double.tryParse(element["height"].toString()) ?? 0,
            weight: double.tryParse(element["weight"].toString()) ?? 0,
            name: element["name"].toString(),
            result: element["result"].toString(),
            id: int.parse(element["id"].toString()),
          ),
        );
      }
    } catch (e) {
      print("Erro para obter os dados do banco de dados: $e");
    }
    return imcResults;
  }

  static Future<int> saveNewImcAndReturnId({
    required ImcModel imcModel,
  }) async {
    int id = 0;
    try {
      var db = await SQFLiteDataBase._getDatabase();
      id = await db.rawInsert(
          'INSERT INTO imc (height, weight, name, imcResult) values(?,?,?,?)', [
        imcModel.height,
        imcModel.weight,
        imcModel.name,
        imcModel.result,
      ]);
    } catch (e) {
      print("erro para salvar o imc no banco de dados: $e");
    }

    return id;
  }

  // static Future<void> update({
  //   required ImcModel imcModel,
  // }) async {
  //   var db = await SQFLiteDataBase._getDatabase();
  //   await db.rawInsert(
  //       'UPDATE imc SET imcResult = ?, height = ?, name = ?, weight = ? WHERE id = ?',
  //       [
  //         imcModel.result,
  //         imcModel.height,
  //         imcModel.name,
  //         imcModel.weight,
  //       ]);
  // }

  static Future<void> remove({required int id}) async {
    var db = await SQFLiteDataBase._getDatabase();
    await db.rawInsert('DELETE FROM imc WHERE id = ?', [id]);
  }
}
