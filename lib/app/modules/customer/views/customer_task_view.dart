import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/components/empty_widget.dart';
import 'package:tailor/app/modules/Customer/model/Customers.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import '../../../components/build_task_tiles.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../../task/model/tasks.dart';
import '../../task/views/creat_task_dialog.dart';
import '../../task/views/task_view.dart';
import '../controllers/customer_controller.dart';

class CustomerTaskView extends StatefulWidget {
  CustomerTaskView({super.key, required this.customerId, required this.name});

  final int customerId;
  final String name;

  @override
  State<CustomerTaskView> createState() => _CustomerTaskViewState();
}

class _CustomerTaskViewState extends State<CustomerTaskView> {
  final taskController = Get.find<TaskController>();

  void _refreshScreen() => setState((){});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} Tasks'),
        leading: IconButton(onPressed: () {
          print('back');
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back, color: Colors.white,),),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<List<MyTask>>(
        future: taskController.taskByCustomer(widget.customerId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final filteredTasks = snapshot.data!;
            final todayPendingTasks = filteredTasks
                .where((task) => task.taskStatus == strTaskStatusPending ||
                task.taskStatus == strTaskStatusOverDue)
                .toList();
            final todayCompletedTasks = filteredTasks
                .where((task) => task.taskStatus == strTaskStatusComplete)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 16),
                  child: Text(
                    'Pending Tasks',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                BuildTaskTiles(
                  taskList: todayPendingTasks,
                  emptyMsg: 'There is no pending tasks',
                  callback: _refreshScreen,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 16),
                  child: Text(
                    'Completed Tasks',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                BuildTaskTiles(
                  taskList: todayCompletedTasks,
                  emptyMsg: 'There is no completed tasks',
                  callback: _refreshScreen,
                ),
              ],
            );
          } else {
            return Center(child: const CircularProgressIndicator()); // Loading indicator
          }
        },
      ),
      // Add more UI components here if needed
    );
  }
}