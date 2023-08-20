import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../components/build_task_tiles.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../../task/controllers/task_controller.dart';
import '../../task/model/tasks.dart';
import '../../task/views/creat_task_dialog.dart';
import '../../task/views/task_view.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  ExploreView({Key? key}) : super(key: key);
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('Explore'),
            actions: [
                IconButton(
                  onPressed: () => Get.to(CreateTaskDialog()),
                  icon: const Icon(
                    IconlyBold.plus,
                    color: Colors.white,
                  ),
                ),
              IconButton(
                  onPressed: () => controller.showFilterTab.value =
                      !controller.showFilterTab.value,
                  icon: const Icon(
                    Icons.search_off_outlined,
                    color: Colors.white,
                  ))
            ],
          ),
          drawer: CustomDrawer(),
          body: Column(
            children: [
              if (controller.showFilterTab.value)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05,),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: context.textTheme.displaySmall,
                          ),
                          TextButton(
                            onPressed: () => controller.clearFilters(),
                            child: const Text(
                              'Clear Filters',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          hintText: 'Customer Phone',
                          hintStyle: context.textTheme.bodySmall,
                        ),
                      ),
                      TextFormField(
                        controller: controller.customerNameController,
                        decoration: InputDecoration(
                          hintText: 'Customer Name',
                          hintStyle: context.textTheme.bodySmall,
                        ),
                      ),
                      TextFormField(
                        controller: controller.statusController,
                        decoration: InputDecoration(
                          hintText:
                              "Status: Type \"PENDING\" or \"COMPLETED\" or \"OVERDUE\"",
                          hintStyle: context.textTheme.bodySmall,
                        ),
                      ),
                      TextFormField(
                        controller: controller.dateController,
                        readOnly: true,
                        onTap: () async =>
                            await controller.selectDate(context),
                        decoration: InputDecoration(
                          hintText: "Pick a date",
                          suffixIcon: Icon(
                            Icons.today,
                            color: context.theme.primaryColor,
                          ),
                          border: const UnderlineInputBorder(),
                          hintStyle: context.textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.applyFilter();
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Applied Filters: ',
                          style: context.textTheme.displaySmall!
                              .copyWith(fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (controller.filters.value.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('(0)',
                              style: context.textTheme.displaySmall!
                                  .copyWith(fontSize: 18)),
                        ),
                      ...controller.filters.value.entries
                          .where((entry) => entry.value.isNotEmpty)
                          .map((entry) => FilterChip(
                                padding: const EdgeInsets.all(5),
                                label: Text('${entry.key}: ${entry.value}'),
                                onSelected: (_) {},
                              ))
                          .toList()
                    ],
                  ),
                ),
              ),

              Obx(
                () => BuildTaskTiles(
                  taskList: controller.filteredTasks.value,
                ),
              )
            ],
          ),
        ));
  }
}
