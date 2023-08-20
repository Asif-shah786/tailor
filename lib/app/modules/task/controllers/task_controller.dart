import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/tasks_db.dart';
import '../model/tasks.dart';
String kAll = 'all', kToday = 'today', kDate = 'date';
class TaskController extends GetxController {


  final StreamController<List<MyTask>> _taskController =
      StreamController<List<MyTask>>.broadcast();
  Stream<List<MyTask>> get tasks => _taskController!.stream;
  RxBool isError = false.obs;
  final now = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  RxString searchQuery = ''.obs;
  RxBool showSearch = true.obs;
  Rx<DateTime?> filteredDate = Rx<DateTime?>(null);//DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;
  late TaskDB _taskDB;
  RxString selectedBtn = kAll.obs;

  Stream<List<MyTask>> createTodayTaskStream() {
    return tasks.map((taskList) =>
        taskList.where((task) => _isToday(task.dueDate)).toList());
  }

  Future<void> refreshDues() async {
    await _taskDB.markTaskOverDue();
    refresh();
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
    // filteredDate.value = DateTime(now.year, now.month, now.day);
    _loadTasks();
    filteredDate.listen((DateTime? p0) async {
      if(p0 != null)print('Filtered Date : ${p0.day.toString()}');
      _loadTasks();
    });
    super.onInit();
  }

  @override
  void dispose() {
    _taskController.close();
    searchFocusNode.dispose();
    searchController.dispose();
  }

  void _loadTasks() {
    final value = filteredDate.value;
    selectedBtn.value = value == null ? kAll  : value == DateTime(now.year, now.month, now.day) ? kToday : kDate;
    print(selectedBtn.value);
    _taskDB.getFilteredTasksStream(date: filteredDate.value).then((tasks) {
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
          customerName: customerName, status: status, date: date);


  Future<List<MyTask>> taskByCustomer(int customerId) async =>
      await _taskDB.getTaskByCustomer(customerId);

  Future<void> markTask(MyTask task, String status, int? shelfAfter) async {
    if (shelfAfter == null) {
      // Marking Pending
      if (DateTime.fromMicrosecondsSinceEpoch(task.dueDate)
          .isBefore(DateTime(now.year, now.month, now.day))) {
        await _taskDB.updateTaskFields(task, {
          MyTask.dbStatus: strTaskStatusOverDue,
          MyTask.dbCompletedDate: -1,
          MyTask.dbShelfAfter: -1,
        }).then((value) {
          _loadTasks();
        });
      } else {
        await _taskDB.updateTaskFields(task, {
          MyTask.dbStatus: status,
          MyTask.dbCompletedDate: -1,
          MyTask.dbShelfAfter: -1,
        }).then((value) {
          _loadTasks();
        });
      }
    } else {
      final today =
          DateTime(now.year, now.month, now.day).microsecondsSinceEpoch;
      await _taskDB.updateTaskFields(task, {
        MyTask.dbStatus: status,
        MyTask.dbCompletedDate: today,
        MyTask.dbShelfAfter: shelfAfter,
      }).then((value) {
        _loadTasks();
      });
    }
  }

  Future<void> createTask(MyTask MyTask) async {
    _taskDB.insertOrReplace(MyTask).then((value) {
      _loadTasks();
    });
  }

  Future<void> delete(int taskId) async {
    await _taskDB.deleteTask(taskId);
    _loadTasks();
  }

  Future<void> deleteWithAlert(int taskId) async {
    // Show an AlertDialog to confirm the deletion
    bool? confirmDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this Task?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.primaryColor,
            ),
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.primaryColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await delete(taskId);
    }
    Get.back();
  }

  void refresh() {
    _loadTasks();
  }
}
