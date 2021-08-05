import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:sqflite/sqflite.dart';
import '../main.dart';

enum Status { deleted }

class DatabaseHelper {
  static Database _database;
  static String db_name = '${user.name}.db';
  static const String table_name = 'employee';

  static const String message_table = 'message';
  static const String contact_table = 'contact';

  static const String id = 'id';
  static const String name = 'name';

  static const String first_name = 'first_name';
  static const String last_name = 'last_name';
  static const String number = 'number';
  static const String address = 'address';
  static const String email = 'email';
  static const String company = 'company';

  static const String direction = 'direction';
  static const String receiver = 'receiver';
  static const String sender = 'sender';
  static const String sms_id = 'sms_id';
  static const String status = 'status';
  static const String text = 'text';
  static const String timestamp = 'timestamp';

  var DB;

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await initDb();
    return _database;
  }

  Future deleteDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, db_name);

    try {
      _database.close();
      await deleteDatabase(path);
      _database = null;
    } catch (e) {
      print(e.toString());
    }
    print('deleting db');
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, db_name);

    DB = await openDatabase(path, version: 1, onCreate: _onCreate);

    return DB;
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
        $company TEXT, 
        $status TEXT
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
    contact.status = 'active';
    contact.id = await dbClient.insert(contact_table, contact.toMap(contact));

    return contact;
  }

  Future<List<Contact>> getContacts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(contact_table, columns: [
      id,
      first_name,
      last_name,
      number,
      address,
      email,
      company,
      status
    ]);

    List<Contact> contacts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        if (maps[i]['status'] == 'deleted') {
          continue;
        }
        contacts.add(Contact.fromMap(maps[i]));
      }
    }

    return contacts;
  }

  Future<List<Map>> searchContact(Contact contact) async {
    var dbClient = await db;
    List<Map> contacts = await dbClient.query(contact_table,
        where: '$number = ?', whereArgs: [contact.number]);
    print(contacts);
    if (contacts.isEmpty) {
      return [];
    }
    if (contacts[0]['status'] == 'deleted') {
      return [];
    }
    return contacts;
  }

  Future<bool> contactExists(Contact contact) async {
    var dbClient = await db;
    List<Map> recieverMapList = await dbClient.query(contact_table,
        where: '$number = ?', whereArgs: [contact.number]);

    if (recieverMapList.isEmpty || recieverMapList[0]['status'] == 'deleted') {
      return false;
    }

    return true;
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.update(contact_table, contact.toMap(contact),
        where: '$number = ?', whereArgs: [contact.number]);
  }

  Future<int> deleteContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.delete(contact_table,
        where: '$number = ?', whereArgs: [contact.number]);
  }

  Future<Message> createMessage(Message message) async {
    var dbClient = await db;
    await dbClient.insert(message_table, message.toMap());

    return message;
  }

  Future<bool> searchMessages(Message message) async {
    var dbClient = await db;

    List<Message> messages = [];

    List<Map> recieverMapList = await dbClient.query(message_table,
        where: '$sms_id = ?', whereArgs: [message.sms_id]);

    if (recieverMapList.isEmpty) {
      return false;
    }

    return true;
  }

  Future<int> deleteMessages(Message message) async {
    var dbClient = await db;
    message.status = 'deleted';
    return await dbClient.update(message_table, message.toMap(),
        where: '$sms_id = ?', whereArgs: [message.sms_id]);
  }

  // ignore: missing_return
  Future<int> deleteChat(String number) async {
    var dbClient = await db;
    Message tempMessage = Message(receiver: number, status: 'deleted');

    await dbClient.update(message_table, {'status': 'deleted'},
        where: '$receiver = ?', whereArgs: [number]);
    print(await dbClient
        .query(message_table, where: '$receiver = ?', whereArgs: [number]));
    tempMessage = Message(sender: number, status: 'deleted');
    await dbClient.update(message_table, {'status': 'deleted'},
        where: '$sender = ?', whereArgs: [number]);
    print(await dbClient
        .query(message_table, where: '$receiver = ?', whereArgs: [number]));
  }

  Future<List<Message>> getMessages() async {
    var dbClient = await db;
    List maps = await dbClient.query(message_table, columns: [
      sms_id,
      direction,
      receiver,
      sender,
      status,
      text,
      timestamp
    ]);

    List<Message> messages = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        if (maps[i]['status'] == 'deleted') {
          continue;
        }
        messages.add(Message.fromMap(maps[i]));
      }
    }

    return messages;
  }
}
