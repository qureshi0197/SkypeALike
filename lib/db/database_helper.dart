import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'model/employee.dart';

class DatabaseHelper{
  static Database _database;
  static const String db_name = 'employee.db';
  static const String table_name = 'employee';
  static const String id = 'id';
  static const String name = 'name';

  Future<Database> get db async {
    if(_database != null) {
      return _database;
    }

    _database = await initDb();
    return _database;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , db_name);

    var db = await openDatabase(path, version:1, onCreate: _onCreate);

    return db;
  }

// On creation of database call onCreate which creates all the tables required in the database
  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table_name ($id INTEGER PRIMARY KEY, $name TEXT) 
    ''');
  }

// ADD AN EMPLOYEE IN DATABASE
  Future<Employee> save(Employee employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(table_name, employee.toMap());
    
    return employee;

    /* RAW QUERY 
    await dbClient.Transaction((txn) async {
      var query = "INSERT INTO $table_name ($name) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

// GET EMPLOYEES FROM DATABASE
  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table_name, columns: [id, name]);
    
    // RAW QUERY
    // List<Map> maps = await dbClient.query("SELECT * FROM table_name");

    // ADD DATA FETCHED IN MAPS TO EMPLOYEE LIST THROUGH LOOP 
    List<Employee> employees = [];
    if(maps.length > 0) {
      for(int i = 0 ; i < maps.length ; i++){
        employees.add(Employee.fromMap(maps[i]));
      }
    }

    return employees;
  }

  // Future<int> delete(int id) async {
  //   var dbClient = await db;
  //   return await dbClient.delete(table_name, where: '$id = ?', whereArgs: [id]);
  // }


  // THERE IS SOME ISSUE WITH DELETE FUNCTION -> FIX IT (Note to Myself)
  // Deletes all entries
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table_name, where: '$id = ?', whereArgs: [id]);
  }

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    return await dbClient.update(table_name, employee.toMap(), where: '$id = ?', whereArgs: [employee.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}