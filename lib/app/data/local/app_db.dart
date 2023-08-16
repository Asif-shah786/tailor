import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../../modules/task/model/tasks.dart';
import '../../modules/customer/model/customers.dart';

/// This is the singleton database class which handlers all database transactions
/// All the task raw queries is handle here and return a Future<T> with result
class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  late Database _database;

  static AppDatabase get() {
    print('AppDatabase get Called');
    print('get');
    return _appDatabase;
  }

  bool didInit = false;

  /// Use this method to access the database which will provide you future of [Database],
  /// because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    print('getDb');
    await _init();
    return _database;
  }

  Future _init() async {
    print('INIT');
    // Get a location using path_provider
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '';
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = 'my_web_web.db';
    } else {
      Directory directory = await getApplicationDocumentsDirectory();
      path = join(directory.path, 'tailor_app.db');
    }

    // String path = join(documentsDirectory.path, "tailor_app.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await _createCustomerTable(db);
      await _createTaskTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${Customer.tblCustomer}");
      await db.execute("DROP TABLE ${MyTask.tblTask}");
      await _createCustomerTable(db);
      await _createTaskTable(db);
    });
    didInit = true;
  }

  Future _createCustomerTable(Database db) {
    return db.transaction((txn) async {
      await txn.execute("CREATE TABLE ${Customer.tblCustomer} ("
          "${Customer.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Customer.dbName} TEXT,"
          "${Customer.dbPhone} TEXT,"
          "${Customer.dbAddress} TEXT,"
          "${Customer.dbCreatedDate} INT)");
      // await txn.rawInsert(
      //     'INSERT INTO ${Customer.tblCustomer}(${Customer.dbId},${Customer.dbName},${Customer.dbPhone},${Customer.dbAddress},${Customer.dbCreatedDate})'
      //     ' VALUES(? ,?,  ? , ?, ?) ',
      //     [0, "Asif", "+923015544682", "Ghazi, Kpk, Pakistan", "-1"]);
    });
  }

  Future _createTaskTable(Database db) {
    return db.transaction((Transaction txn) async {
      await txn.execute("CREATE TABLE ${MyTask.tblTask} ("
          "${MyTask.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${MyTask.dbTitle} TEXT,"
          "${MyTask.dbDetail} TEXT,"
          "${MyTask.dbItemType} TEXT,"
          "${MyTask.dbPriority} TEXT,"
          "${MyTask.dbStatus} TEXT,"
          "${MyTask.dbCreatedDate} LONG,"
          "${MyTask.dbDueDate} LONG,"
          "${MyTask.dbCustomerId} INTEGER,"
          "${MyTask.dbCustomerName} TEXT,"
          "${MyTask.dbShelfBefore} INTEGER,"
          "${MyTask.dbShelfAfter} INTEGER,"
          "${MyTask.dbPrice} REAL,"
          "FOREIGN KEY(${MyTask.dbCustomerId}) REFERENCES ${Customer.tblCustomer} (${Customer.dbId}) ON DELETE CASCADE);");

      // await txn.rawInsert(
      //     'INSERT INTO ${MyTask.tblTask}(${MyTask.dbId}, ${MyTask.dbTitle},${MyTask.dbDetail},${MyTask.dbItemType},${MyTask.dbPriority},${MyTask.dbStatus},${MyTask.dbCreatedDate},${MyTask.dbDueDate},${MyTask.dbCustomerId},${MyTask.dbCustomerName},  ${MyTask.dbShelfBefore}, ${MyTask.dbShelfAfter})'
      //         ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      //     [0, "Sample Title", "Sample Detail", "Sample ItemType", "Sample Priority", "Sample Status", DateTime.now().millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch, 1, "Sample Customer Name", 0, 0]);
    });
  }
}
