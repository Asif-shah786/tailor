import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../../modules/home-with-restAPI/model/Tasks.dart';
import '../../modules/home-with-restAPI/model/customers.dart';

/// This is the singleton database class which handlers all database transactions
/// All the task raw queries is handle here and return a Future<T> with result
class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  late Database _database;

  static AppDatabase get() {
    return _appDatabase;
  }

  bool didInit = false;

  /// Use this method to access the database which will provide you future of [Database],
  /// because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tailor_app.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await _createCustomerTable(db);
      await _createTaskTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${Customer.tblCustomer}");
      await db.execute("DROP TABLE ${Task.tblTask}");
      await _createCustomerTable(db);
      await _createTaskTable(db);
    });
    didInit = true;
  }


  Future _createCustomerTable(Database db){
    return db.transaction((txn) async {
      await txn.execute(
        "CREATE TABLE ${Customer.tblCustomer}("
            "${Customer.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
            "${Customer.dbName} TEXT,"
            "${Customer.dbPhone} TEXT,"
            "${Customer.dbAddress} TEXT,"
            "${Customer.dbCreatedDate} LONG,)");
    });
  }

  Future _createTaskTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${Task.tblTask} ("
          "${Task.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Task.dbTitle} TEXT,"
          "${Task.dbDetail} TEXT,"
          "${Task.dbItemType} TEXT,"
          "${Task.dbPriority} TEXT,"
          "${Task.dbStatus} TEXT,"
          "${Task.dbCreatedDate} LONG,"
          "${Task.dbDueDate} LONG,"
          "${Task.dbCustomerId} INTEGER,"
          "FOREIGN KEY(${Task.dbCustomerId}) REFERENCES ${Customer.tblCustomer}(${Customer.dbId}) ON DELETE CASCADE);");
      // txn.rawInsert('INSERT INTO '
      //     '${Task.tblTask}(${Task.dbId},${Task.dbTitle},${Task.dbDetail},${Task.dbItemType},${Task.dbPriority},${Task.dbStatus},${Task.dbCreatedDate},${Task.dbDueDate},)'
      //     ' VALUES(1, "Inbox", "Grey", ${Colors.grey.value});');
    });
  }
}
