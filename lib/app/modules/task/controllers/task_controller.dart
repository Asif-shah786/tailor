import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/tasks_db.dart';
import '../model/Tasks.dart';

class TaskController extends GetxController {
  //TODO: Implement TaskController

  final StreamController<List<MyTask>> _taskController =
  StreamController<List<MyTask>>.broadcast();

  Stream<List<MyTask>> get customers => _taskController!.stream;

  late TaskDB _taskDB;

  @override
  void onInit() {
    // TODO: implement onInit
    _taskDB = TaskDB.get();
    super.onInit();
  }

  @override
  void dispose() {
    _taskController.close();
  }

  void _loadTasks() {
    _taskDB.getTasks().then((tasks) {
      if (!_taskController.isClosed) {
        _taskController.sink.add(tasks);
      }
    });
  }

  void createTask(MyTask MyTask) {
    _taskDB.insertOrReplace(MyTask).then((value) {
      if (value == null) {
        Get.snackbar('Error', 'Failed to add customer',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      _loadTasks();
    });
  }


  void refresh() {
    _loadTasks();
  }
}
