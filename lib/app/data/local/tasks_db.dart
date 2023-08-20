import 'package:sqflite/sqflite.dart';

import '../../modules/task/model/tasks.dart';
import 'app_db.dart';

class TaskDB {
  static final TaskDB _taskDb = TaskDB._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  TaskDB._internal(this._appDatabase);

  static TaskDB get() {
    return _taskDb;
  }

  var now = DateTime.now();

  Future<void> updateTaskFields<T>(
      MyTask task, Map<String, dynamic> fieldMap) async {
    var db = await _appDatabase.getDb();
    List<dynamic> values = [];

    // Construct the SET clause for the SQL query
    String setClause = fieldMap.keys.map((fieldName) {
      values.add(fieldMap[fieldName]);
      return '$fieldName = ?';
    }).join(', ');

    await db.rawUpdate(
        'UPDATE ${MyTask.tblTask} SET $setClause WHERE ${MyTask.dbId} = ?',
        [...values, task.id]);
  }

  Future showTask(MyTask task) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ${MyTask.tblTask} '
        'WHERE id = ?  ORDER BY ${MyTask.dbDueDate} DESC',
        [task.id]);
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
    var startDate =
        DateTime(now.year, now.month, now.day); // Start of the current day
    var endDate =
        startDate.add(const Duration(days: 1)); // Start of the next day

    var result = await db.rawQuery(
        'SELECT * FROM ${MyTask.tblTask}'
        ' WHERE ${MyTask.dbDueDate} >= ? AND ${MyTask.dbDueDate} < ? OR ${MyTask.dbCompletedDate} >= ? ORDER BY ${MyTask.dbDueDate} DESC',
        [startDate.microsecondsSinceEpoch, endDate.microsecondsSinceEpoch]);

    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    return tasks;
  }

  Future<List<MyTask>> getTomorrowTasks() async {
    var db = await _appDatabase.getDb();
    final today = DateTime(now.year, now.month, now.day);
    var tomorrow = today.add(const Duration(days: 1));
    var result = await db.rawQuery(
        'SELECT * FROM ${MyTask.tblTask}'
        ' WHERE ${MyTask.dbDueDate} >= ? AND ${MyTask.dbDueDate} <= ? OR '
        '${MyTask.dbCompletedDate} = ? OR status = ? ORDER BY ${MyTask.dbDueDate} DESC',
        [
          today.microsecondsSinceEpoch,
          tomorrow.microsecondsSinceEpoch,
          today.microsecondsSinceEpoch,
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

  Future<List<MyTask>> getFilteredTasksStream({
    DateTime? date,
  }) async {
    var db = await _appDatabase.getDb();
    final queryParameters = <String, dynamic>{};
    final today = DateTime(now.year, now.month, now.day);
    String query =
        'SELECT * FROM ${MyTask.tblTask} WHERE 1=1 '; // Start the query with a true condition

    if (date == null) {
      //All tasks sort by due_date AND OVERDUE
      query += ' ORDER BY ${MyTask.dbDueDate} DESC';
    } else if (date == today) {
      query += ' AND due_date >= ? AND due_date < ?';
      final DateTime nextDay = date.add(const Duration(days: 1));
      queryParameters['due_date_start'] = date.microsecondsSinceEpoch;
      queryParameters['due_date_end'] = nextDay.microsecondsSinceEpoch;

      query += ' OR completed_date >= ? AND completed_date < ?';
      queryParameters['completed_date_start'] = date.microsecondsSinceEpoch;
      queryParameters['completed_date_end'] = nextDay.microsecondsSinceEpoch;

      //Collecting OVERDUE
      query += ' OR ${MyTask.dbStatus} = ? ';
      queryParameters['status'] = strTaskStatusOverDue;

    } else {
      // Assuming the date field is stored as a string in ISO 8601 format in the database
      query += ' AND due_date >= ? AND due_date < ?';
      final DateTime nextDay = date.add(const Duration(days: 1));
      queryParameters['due_date_start'] = date.microsecondsSinceEpoch;
      queryParameters['due_date_end'] = nextDay.microsecondsSinceEpoch;

      query += ' OR completed_date >= ? AND completed_date < ?';
      queryParameters['completed_date_start'] = date.microsecondsSinceEpoch;
      queryParameters['completed_date_end'] = nextDay.microsecondsSinceEpoch;
    }
    print(query);
    print(queryParameters.values.toList());
    final result = await db.rawQuery(query, queryParameters.values.toList());
    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    print('Tasks len : ${tasks.length}');


    return tasks;
  }

  Future<List<MyTask>> getFilteredTasks({
    String customerName = '',
    String status = '',
    DateTime? date,
  }) async {
    var db = await _appDatabase.getDb();
    final queryParameters = <String, dynamic>{};

    String query =
        'SELECT * FROM ${MyTask.tblTask} WHERE 1=1'; // Start the query with a true condition

    if (customerName.isNotEmpty) {
      query += ' AND customer_name LIKE ?';
      queryParameters['customer_name'] =
          '%$customerName%'; // Partial match for customer name
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

  Future<bool> markTaskOverDue() async {
    print('markTaskOverDue Function called');
    final today = DateTime(now.year, now.month, now.day);
    var db = await _appDatabase.getDb();
    try {
      print('Before Query');
      await db.rawQuery(
          'UPDATE ${MyTask.tblTask} SET status = ? WHERE status = ? AND due_date < ? ',
          [
            strTaskStatusOverDue,
            strTaskStatusPending,
            today.microsecondsSinceEpoch
          ]);
      print('Successfully Completed Query Setting Status to OVERDUE');
      return true;
    } catch (e) {
      print('Error Occurred in Setting Status to OVERDUE');
      return false;
    }
  }

  Future<List<MyTask>> getTaskByCustomer(int customerId) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ${MyTask.tblTask} WHERE customer_id = ?', [customerId]);
    List<MyTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      var myTask = MyTask.fromMap(item);
      tasks.add(myTask);
    }
    print(customerId);
    print('Ali tasks $tasks');
    return tasks;
  }

  Future insertOrReplace(MyTask task) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT OR REPLACE INTO '
        '${MyTask.tblTask}(${MyTask.dbDetail},${MyTask.dbItemType},'
        '${MyTask.dbDueDate},${MyTask.dbCreatedDate},${MyTask.dbPriority},'
        '${MyTask.dbStatus},${MyTask.dbCustomerId}, ${MyTask.dbCustomerName},'
        ' ${MyTask.dbCustomerPhone}, ${MyTask.dbShelfBefore}, '
        '${MyTask.dbShelfAfter}, ${MyTask.dbPrice})'
        ' VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          task.detail,
          task.itemType,
          task.dueDate,
          task.createdDate,
          task.taskPriority,
          task.taskStatus,
          task.customerId,
          task.customerName,
          task.customerPhone,
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
          'DELETE FROM ${MyTask.tblTask} WHERE ${MyTask.dbId} = ?;', [taskID]);
    });
  }
}
