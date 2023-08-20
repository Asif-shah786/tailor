import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor/app/modules/task/model/tasks.dart';

import '../../task/controllers/task_controller.dart';

class ExploreController extends GetxController {
  //TODO: Implement ExploreController

  RxList<MyTask> filteredTasks = <MyTask>[].obs;

  RxBool showFilterTab = true.obs;

  final TextEditingController phoneController = TextEditingController(),
      customerNameController = TextEditingController(),
      statusController = TextEditingController(),
      dateController = TextEditingController();

  final taskController = Get.find<TaskController>();
  DateTime dueDate = DateTime.now();

  RxMap filters = {}.obs;

  clearFilters(){
    phoneController.clear();
    customerNameController.clear();
    statusController.clear();
    dateController.clear();
    dueDate = DateTime.now();
    filteredTasks.clear();
    filters.clear();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: context.theme.primaryColor, // Change the primary color to blue
            colorScheme: ColorScheme.light(primary: context.theme.primaryColor), // Change the color scheme to blue
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != dueDate) {
      dueDate = DateTime(picked.year, picked.month, picked.day);
      dateController.text = "${dueDate.toLocal()}".split(' ')[0];
    }
  }

  Future<void> applyFilter() async {
    List<MyTask> tasks = await taskController.getFilteredTasks(
        title: phoneController.text,
        customerName: customerNameController.text,
        status: statusController.text,
        date: dateController.text.isNotEmpty ? dueDate : null);
    updateFilterWidgets();
    filteredTasks.clear();
    filteredTasks.addAll(tasks);
  }

  updateFilterWidgets() {
    // filters.clear();
    if (phoneController.text.isNotEmpty) {
      filters['Title'] = phoneController.text;
    }
    if (customerNameController.text.isNotEmpty) {
      filters['C\' Name'] = customerNameController.text;
    }
    if (statusController.text.isNotEmpty) {
      filters['Status'] = statusController.text;
    }
    if (dateController.text.isNotEmpty) {
      filters["Date"] = dateController.text;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
