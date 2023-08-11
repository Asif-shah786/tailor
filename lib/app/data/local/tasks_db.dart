import 'package:sqflite/sqflite.dart';

import '../../modules/task/model/Tasks.dart';
import 'app_db.dart';

class TaskDB {
  static final TaskDB _taskDb = TaskDB._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  TaskDB._internal(this._appDatabase);

  static TaskDB get() {
    return _taskDb;
  }

  Future<List<MyTask>> getTasks() async {
    var db = await _appDatabase.getDb();
    // var whereClause = isInboxVisible ? ";" : " WHERE ${Task.dbId}!=1;";
    // var result = await db.rawQuery('SELECT * FROM ${Task.tblTask} $whereClause');
    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask}');
    List<MyTask> Tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      Tasks.add(myTask);
    }
    return Tasks;
  }

  static final dbId = "id";
  static final dbTitle = "title";
  static final dbDetail = "detail";
  static final dbItemType = "item_type";
  static final dbDueDate = "due_date";
  static final dbCreatedDate = "created_date";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbCustomerId = "customer_id";

  Future insertOrReplace(MyTask task) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert(
          'INSERT OR REPLACE INTO '
          '${MyTask.tblTask}(${MyTask.dbTitle},${MyTask.dbDetail},${task.itemType},${task.dueDate},${task.createdDate},${task.taskPriority},${task.taskStatus}'
          ' VALUES(?, ?, ?, ?, ?, ?, ?)',
          [
            task.title,
            task.detail,
            task.itemType,
            task.dueDate,
            task.createdDate,
            task.taskPriority,
            task.taskStatus,
            task.customerId
          ]);
    });
  }

  Future deleteTask(int TaskID) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${MyTask.tblTask} WHERE ${MyTask.dbId}==$TaskID;');
    });
  }
}
