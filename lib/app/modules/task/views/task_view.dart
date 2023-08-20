// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
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

  DateTime now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.filteredDate.value ??
          DateTime(now.year, now.month, now.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                context.theme.primaryColor, // Change the primary color to blue
            colorScheme: ColorScheme.light(
                primary: context
                    .theme.primaryColor), // Change the color scheme to blue
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      print(picked.day);
      controller.filteredDate.value =
          DateTime(picked.year, picked.month, picked.day);
      print(controller.filteredDate.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    taskController.refresh();
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: SizedBox(
          height: 30,
          child: Obx(() => Row(
            children: [
              TextButton(
                style: controller.selectedBtn.value  != kAll ? null : TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(),
                  side: BorderSide(color: Colors.white, width: 1),
                ),
                onPressed: () async => controller.filteredDate?.value = null,
                child: Text(
                  'All',
                  style: context.textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                style: controller.selectedBtn.value  != kToday ? null :TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(),
                  side: BorderSide(color: Colors.white, width: 1),
                ),
                onPressed: () async => controller.filteredDate?.value =
                    DateTime(now.year, now.month, now.day),
                child: Text(
                  'Today',
                  style: context.textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              controller.selectedBtn.value  != kDate ? IconButton(
                padding: EdgeInsets.all(3),
                onPressed: () async => await _selectDate(context),
                icon: Icon(
                  Icons.today,
                  color: Colors.white,
                  size: 22,
                ),
              ) :Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(3),
                  onPressed: () async => await _selectDate(context),
                  icon: Icon(
                    Icons.today,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              )
            ],
          )),
        ),
        actions: [
          TextButton(
            onPressed: () async => await controller.refreshDues(),
            child: Text(
              'Refresh Dues',
              style: context.textTheme.titleMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
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
        stream: taskController.tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final filteredTasks = snapshot.data!;
            final pendingTasks = filteredTasks
                .where((task) =>
                    task.taskStatus == strTaskStatusPending ||
                    task.taskStatus == strTaskStatusOverDue)
                .toList()
              ..sort((a, b) => a.taskStatus == strTaskStatusPending ? 1 : -1);
            final completedTasks = filteredTasks
                .where((task) => task.taskStatus == strTaskStatusComplete)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: 'Search in Today Tasks',
                            hintStyle: context.textTheme.titleMedium!
                                .copyWith(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  right: 16), // Adjust this padding as needed
                              child: Icon(
                                IconlyLight.search,
                                size: 26,
                                color: context.iconColor,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            controller.searchQuery.value = value.toLowerCase();
                            controller.update();
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.searchQuery.value = '';
                          controller.searchController.clear();
                          controller.searchFocusNode.unfocus();
                        },
                        child: Text(
                          'Clear Search',
                          style: context.textTheme.titleSmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05, vertical: 16),
                  child: Text(
                    'Pending Tasks',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                BuildTaskTiles(
                  taskList: pendingTasks
                      .where((task) =>
                          task.customerName
                              .toLowerCase()
                              .contains(controller.searchQuery) ||
                          task.customerPhone.toLowerCase().contains(controller
                              .searchQuery)) // Add more conditions if needed
                      .toList(),
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
                  taskList: completedTasks
                      .where((task) =>
                          task.customerName
                              .toLowerCase()
                              .contains(controller.searchQuery) ||
                          task.customerPhone.toLowerCase().contains(controller
                              .searchQuery)) // Add more conditions if needed
                      .toList(),
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
