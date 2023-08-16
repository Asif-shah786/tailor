import 'package:sqflite/sqflite.dart';

import '../../modules/task/model/tasks.dart';
import 'app_db.dart';

class TaskDB {
  static final TaskDB _taskDb = TaskDB._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  TaskDB._internal(this._appDatabase);

  static TaskDB get() {
    print('static TaskDB get');
    return _taskDb;
  }

  var now = DateTime.now();
  var today = DateTime.now();



  Future<void> updateTaskField<T>(MyTask task, String fieldName, T fieldValue, int? shelfAfter) async {
    var db = await _appDatabase.getDb();
    if(shelfAfter == null){
      await db.rawUpdate(
        'UPDATE ${MyTask.tblTask} SET $fieldName = ?  WHERE ${MyTask.dbId} = ?',
        [fieldValue, task.id],
      );
    }else{
      print('UPdate with shelf After : $shelfAfter');
      await db.rawUpdate(
        'UPDATE ${MyTask.tblTask} SET $fieldName = ?, ${MyTask.dbShelfAfter} = ? WHERE ${MyTask.dbId} = ?',
        [fieldValue,shelfAfter, task.id],
      );
    }

  }

  Future showTask(MyTask task) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask} '
        'WHERE id = ?  ORDER BY ${MyTask.dbDueDate} DESC', [task.id]);
    print(result.isNotEmpty ? result[0] : []);
    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      // print(item);
      // item.forEach((key, value) {
      //   print('$key $value ${value.runtimeType}');
      // });
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
  }


  Future<List<MyTask>> getTasks() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask}'
        ' ORDER BY ${MyTask.dbDueDate} DESC');
    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    return tasks;
  }

  Future<List<MyTask>> getTodayTasks() async {
    var db = await _appDatabase.getDb();
    var startDate = DateTime(now.year, now.month, now.day); // Start of the current day
    var endDate = startDate.add(const Duration(days: 1)); // Start of the next day

    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask}'
        ' WHERE due_date >= ? AND due_date < ?  ORDER BY ${MyTask.dbDueDate} DESC', [
      startDate.microsecondsSinceEpoch,
      endDate.microsecondsSinceEpoch
    ]);

    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    return tasks;
  }

  Future<List<MyTask>> getTomorrowTasks() async {
    var db = await _appDatabase.getDb();
    var tomorrow = today.add(const Duration(days: 1));
    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask}'
        ' WHERE due_date >= ? AND due_date < ? OR status = ? ORDER BY ${MyTask.dbDueDate} DESC', [
      today.microsecondsSinceEpoch,
      tomorrow.microsecondsSinceEpoch,
      strTaskStatusOverDue
    ]);

    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }

    print(tasks.length);
    return tasks;
  }


  Future<List<MyTask>> getFilteredTasks({
    String title = '',
    String customerName = '',
    String status = '',
    DateTime? date,
  }) async {
    var db = await _appDatabase.getDb();
    final queryParameters = <String, dynamic>{};

    String query = 'SELECT * FROM ${MyTask.tblTask} WHERE 1=1'; // Start the query with a true condition

    if (title.isNotEmpty) {
      query += ' AND title LIKE ?';
      queryParameters['title'] = '%$title%'; // Partial match for title
    }

    if (customerName.isNotEmpty) {
      query += ' AND customer_name LIKE ?';
      queryParameters['customer_name'] = '%$customerName%'; // Partial match for customer name
    }

    if (status.isNotEmpty) {
      query += ' AND status = ?';
      queryParameters['status'] = status;
    }

    if (date != null) {
      // Assuming the date field is stored as a string in ISO 8601 format in the database
      query += ' AND due_date >= ? AND due_date < ?';
      final DateTime nextDay = date.add(Duration(days: 1));
      queryParameters['due_date_start'] = date.microsecondsSinceEpoch;
      queryParameters['due_date_end'] = nextDay.microsecondsSinceEpoch;
    }


    final result = await db.rawQuery(query, queryParameters.values.toList());

    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }

    return tasks;
  }

  Future<bool> markTaskOverDue() async{
    print('markTaskOverDue Function called');
    var db = await _appDatabase.getDb();
    try {
      print('Before Query');
      await db.rawQuery(
          'UPDATE ${MyTask.tblTask} SET status = ? WHERE status = ? AND due_date < ? ',
          [strTaskStatusOverDue, strTaskStatusPending, today.microsecondsSinceEpoch]);
      print('Successfully Completed Query Setting Status to OVERDUE');
      return true;
    } catch(e){
      print('Error Occurred in Setting Status to OVERDUE');
      return false;
    }
  }


  Future<List<MyTask>> getTaskByCustomer (int customerId) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${MyTask.tblTask} WHERE customer_id = ?', [
      customerId
    ]);
    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    return tasks;
  }







  Future insertOrReplace(MyTask task) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT OR REPLACE INTO '
            '${MyTask.tblTask}(${MyTask.dbTitle},${MyTask.dbDetail},${MyTask.dbItemType},'
            '${MyTask.dbDueDate},${MyTask.dbCreatedDate},${MyTask.dbPriority},'
            '${MyTask.dbStatus},${MyTask.dbCustomerId}, ${MyTask.dbCustomerName}, ${MyTask.dbShelfBefore}, ${MyTask.dbShelfAfter}, ${MyTask.dbPrice})'
            ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          task.title,
          task.detail,
          task.itemType,
          task.dueDate,
          task.createdDate,
          task.taskPriority,
          task.taskStatus,
          task.customerId,
          task.customerName,
          task.shelfBefore,
          task.shelfAfter,
          task.price,
        ],
      );

    });
  }

  Future<void> deleteTask(int taskID) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${MyTask.tblTask} WHERE ${MyTask.dbId} = ?;', [
            taskID
      ]);
    });
  }
}
