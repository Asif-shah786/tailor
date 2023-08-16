// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import 'package:tailor/app/modules/task/views/creat_task_dialog.dart';
import '../../../components/build_task_tiles.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../../customer/controllers/customer_controller.dart';
import '../model/tasks.dart';

class TaskView extends GetView<TaskController> {
  TaskView({Key? key}) : super(key: key);

  final TaskController taskController = Get.put(TaskController());
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    taskController.refresh();
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            onPressed: () => Get.to(CreateTaskDialog()),
            icon: const Icon(
              IconlyBold.plus,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<MyTask>>(
        stream: taskController.tomTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final filteredTasks = snapshot.data!;
            final todayPendingTasks = filteredTasks
                .where((task) => task.taskStatus == strTaskStatusPending ||
                task.taskStatus == strTaskStatusOverDue )
                .toList();
            final todayCompletedTasks = filteredTasks
                .where((task) => task.taskStatus == strTaskStatusComplete)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05, vertical: 16),
                  child: Text(
                    'Pending Tasks',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                BuildTaskTiles(
                  taskList: todayPendingTasks,
                  emptyMsg: 'There is no pending tasks',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05, vertical: 16),
                  child: Text(
                    'Completed Tasks',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                BuildTaskTiles(
                  taskList: todayCompletedTasks,
                  emptyMsg: 'There is no completed tasks',
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator(); // Loading indicator
          }
        },
      ),
    );
  }
}

