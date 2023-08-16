import 'dart:async';
import 'package:get/get.dart';
import '../../../data/local/tasks_db.dart';
import '../model/tasks.dart';

class TaskController extends GetxController {
  //TODO: Implement TaskController

  final StreamController<List<MyTask>> _taskController =
      StreamController<List<MyTask>>.broadcast();
  final StreamController<List<MyTask>> _tomorrowTaskController =
      StreamController<List<MyTask>>.broadcast();
  Stream<List<MyTask>> get tasks => _taskController!.stream;
  Stream<List<MyTask>> get tomTasks => _tomorrowTaskController!.stream;
  RxBool isError = false.obs;

  late TaskDB _taskDB;

  Stream<List<MyTask>> createTodayTaskStream() {
    return tasks.map((taskList) =>
        taskList.where((task) => _isToday(task.dueDate)).toList());
  }

  bool _isToday(int timeSinceEpoch) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(
        timeSinceEpoch * 1000); // Convert to milliseconds

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _taskDB = TaskDB.get();
    _loadTasks();
    _loadTomTasks();
    super.onInit();
  }

  @override
  void dispose() {
    _taskController.close();
    _tomorrowTaskController.close();
  }

  void _loadTasks() {
    _taskDB.getTasks().then((tasks) {
      if (!_taskController.isClosed) {
        _taskController.sink.add(tasks);
      }
    });
  }

  Future<List<MyTask>> getFilteredTasks({
    String title = '',
    String customerName = '',
    String status = '',
    DateTime? date,
  }) async =>
      await _taskDB.getFilteredTasks(
          title: title, customerName: customerName, status: status, date: date);

  void _loadTomTasks() {
    _taskDB.getTomorrowTasks().then((tasks) {
      if (!_tomorrowTaskController.isClosed) {
        _tomorrowTaskController.sink.add(tasks);
      }
    });
  }

  Future<void> delete(int taskID) async =>
      _taskDB.deleteTask(taskID).whenComplete(() {
        _loadTasks();
        _loadTomTasks();
      });

  Future<List<MyTask>> taskByCustomer(int customerId) async =>
      await _taskDB.getTaskByCustomer(customerId);

  Future<void> markTask(MyTask task, String status, int? shelfAfter) async {
    await _taskDB
        .updateTaskField(task, MyTask.dbStatus, status, shelfAfter)
        .then((value) {
      _loadTasks();
      _loadTomTasks();
    });
  }

  Future<void> createTask(MyTask MyTask) async {
    _taskDB.insertOrReplace(MyTask).then((value) {
      _loadTasks();
      _loadTomTasks();
    });
  }

  void deleteTask(int taskId) async {
    await _taskDB.deleteTask(taskId);
    _loadTasks();
    _loadTomTasks();
  }

  void refresh() {
    _loadTasks();
    _loadTomTasks();
  }
}
