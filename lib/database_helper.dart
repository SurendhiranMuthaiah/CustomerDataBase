import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const _databaseName = 'CustomerDetailsDB.db';
  static const _databaseVersion = 4;


  static const customerDetailsTable = 'CustomerTable';

  static const colId = '_id';

  static const colCustomerName = '_name';
  static const colMobileNo = '_contact_no';
  static const colDesignation = '_designation';
  static const colemail = '_email';

  late Database _db;

  Future<void> initialization() async {
    final documetsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documetsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion ,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
    
    CREATE TABLE $customerDetailsTable(
    $colId INTEGER PRIMARY KEY,
    $colCustomerName TEXT,
    $colDesignation TEXT,
    $colMobileNo Text,
    $colemail TEXT
    
    )   
   ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async {
    await database.execute('drop table $customerDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertCustomerDetails(
      Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> updateCustomerDetails(
      Map<String, dynamic> row, String tableName) async {
    int id = row[colId];
    return await _db.update(
      tableName,
      row,
      where: '$colId=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCustomerDetails(int id, String tableName) async {
    return await _db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}
