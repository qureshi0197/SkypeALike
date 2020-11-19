import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'model/employee.dart';

class DatabaseHelper{
  static Database _database;
  static const String db_name = 'customer.db';
  static const String table_name = 'employee';
  
  static const String message_table = 'message';
  static const String contact_table = 'contact';

  static const String id = 'id';
  static const String name = 'name';

// CONTACT TABLE COLUMN NAMES
  static const String first_name = 'first_name';
  static const String last_name = 'last_name';
  static const String number = 'number';
  static const String address = 'address';
  static const String email = 'email';
  static const String company = 'company';

// MESSAGE TABLE COLUMN NAMES
  static const String direction = 'direction';
  static const String receiver = 'receiver';
  static const String sender = 'sender';
  static const String sms_id = 'sms_id';
  static const String status = 'status';
  static const String text = 'text';
  static const String timestamp = 'timestamp';


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

    await db.execute('''
      CREATE TABLE $contact_table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT, 
        $first_name TEXT,
        $last_name TEXT, 
        $number TEXT, 
        $address TEXT, 
        $email TEXT, 
        $company TEXT  
        ) 
    ''');

    await db.execute('''
      CREATE TABLE $message_table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $sms_id TEXT,
        $direction TEXT,
        $receiver TEXT,
        $sender TEXT,
        $status TEXT,
        $text TEXT,
        $timestamp TEXT
        ) 
    ''');

  }

  Future<Contact> createContact(Contact contact) async {
    var dbClient = await db;
    
    contact.id = await dbClient.insert(contact_table, contact.toMap(contact));
    
    // print(contact);
    return contact;

    /* RAW QUERY 
    await dbClient.Transaction((txn) async {
      var query = "INSERT INTO $table_name ($name) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<Contact>> getContacts() async {
    var dbClient = await db;
    // await dbClient.delete(contact_table, where: '$id = ?', whereArgs: []);
    List<Map> maps = await dbClient.query(contact_table, 
      columns: [
        id,
        first_name,
        last_name,
        number,
        address,
        email,
        company,
        ]);
    
    // RAW QUERY
    // List<Map> maps = await dbClient.query("SELECT * FROM table_name");

    // ADD DATA FETCHED IN MAPS TO CONTACT LIST THROUGH LOOP 
    List<Contact> contacts = [];
    if(maps.length > 0) {
      for(int i = 0 ; i < maps.length ; i++){
        contacts.add(Contact.fromMap(maps[i]));
      }
    }

    return contacts;
  }

  Future<List<Map>> searchContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.query(contact_table, 
    where: '$number = ?', 
    whereArgs: [contact.number]);
  }

  Future<bool> contactExists(Contact contact) async {
    var dbClient = await db;
    List<Map> recieverMapList =  await dbClient.query(contact_table, 
    where: '$number = ?', 
    whereArgs: [contact.number]);

    if(recieverMapList.isEmpty){
      return false;
    }
    
    return true;
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    contact.number = '+'+contact.number;
    return await dbClient.update(contact_table, contact.toMap(contact), 
    where: '$number = ?', 
    whereArgs: [contact.number]);
  }
  


  Future<Message> createMessage(Message message) async {
    var dbClient = await db;
    await dbClient.insert(message_table, message.toMap());
    
    // print(message);
    return message;
  }

  Future<bool> searchMessages(Message message) async {
    var dbClient = await db;
    
    List<Message> messages = [];

    List<Map> recieverMapList =  await dbClient.query(message_table, 
    where: '$sms_id = ?', 
    whereArgs: [message.sms_id]);

    if(recieverMapList.isEmpty){
      return false;
    }
    
    return true;
 
    // for (Map item in recieverMapList) {
    //   messages.add(Message.fromMap(item));
    // }

    // List<Map> senderMapList =  await dbClient.query(message_table, 
    // where: '$sender = ?', 
    // whereArgs: [contact.number]);
    // for (Map item in senderMapList) {
    //   messages.add(Message.fromMap(item));
    // }

    // return messages;/

    // List<Message> receiver_messages = await dbClient.query(message_table, 
    // where: '$receiver = ?', 
    // whereArgs: [message.receiver]); 
    // return 
  }

  Future<List<Message>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(message_table, 
      columns: [
        sms_id,
        direction,
        receiver,
        sender,
        status,
        text,
        timestamp
        ]);
    
    List<Message> messages = [];
    if(maps.length > 0) {
      for(int i = 0 ; i < maps.length ; i++){
        messages.add(Message.fromMap(maps[i]));
      }
    }

    return messages;
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

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    return await dbClient.update(table_name, employee.toMap(), where: '$id = ?', whereArgs: [employee.id]);
  }

  // THERE IS SOME ISSUE WITH DELETE FUNCTION -> FIX IT (Note to Myself)
  // Deletes all entries
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table_name, where: '$id = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}