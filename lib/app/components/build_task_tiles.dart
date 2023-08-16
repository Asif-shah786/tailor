import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../modules/task/controllers/task_controller.dart';
import '../modules/task/model/tasks.dart';

class BuildTaskTiles extends StatefulWidget {
  BuildTaskTiles({super.key, required this.taskList, this.emptyMsg = ''});
  final List<MyTask> taskList;
  final String emptyMsg;

  @override
  State<BuildTaskTiles> createState() => _BuildTaskTilesState();
}

class _BuildTaskTilesState extends State<BuildTaskTiles> {
  final TaskController controller = Get.find<TaskController>();
  final _shelAfterController = TextEditingController();


@override
  void dispose() {
    // TODO: implement dispose
  _shelAfterController.dispose();
    super.dispose();
  }

  Future<void> markTaskCompleted(BuildContext context, MyTask task) async {
    _shelAfterController.clear();
    await Get.defaultDialog(
      confirm: ElevatedButton(
          onPressed: () async {
            if (_shelAfterController.text.isEmpty) {
              return;
            }
            print(_shelAfterController.text);
            await controller.markTask(task, strTaskStatusComplete,
                int.parse(_shelAfterController.text));
            _shelAfterController.clear();
            Get.back();
          },
          child: const Text('Confirm')),
      cancel: ElevatedButton(
          onPressed: () async {
            _shelAfterController.clear();
            Get.back();
          },
          child: const Text('Cancel')),
      title: 'Enter After Shelf Number',
      content: Column(
        children: [
          TextFormField(
            controller: _shelAfterController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // Allows only digits
            decoration: InputDecoration(
              hintText: 'Enter shelf Number',
              hintStyle: Theme.of(context).textTheme.bodySmall,
            ),
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return 'Shelf Number is required';
              }

              // Additional validation to check if the input is a valid integer
              if (int.tryParse(text) == null) {
                return 'Please enter a valid integer';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.taskList.isEmpty) {
      return Expanded(
          child: Center(
              child: Text(
        widget.emptyMsg,
        style: context.textTheme.titleSmall,
      )));
    }
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        itemCount: widget.taskList.length,
        itemBuilder: (BuildContext context, int index) {
          MyTask task = widget.taskList[index];
          bool overDueTask = task.taskStatus == strTaskStatusOverDue;
          ShapeBorder shape =
              getTileShapeWithIndex(index == widget.taskList.length - 1 ? -1 : index);
          return Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            shape: shape,
            child: ExpansionTile(
              textColor: Colors.black87,
              iconColor: theme.iconTheme.color,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: shape,
              backgroundColor: theme.splashColor,
              key: ValueKey(task.id),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.title,
                      style:
                          const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                  if(overDueTask) const Icon(Icons.watch_later, color: Colors.red,)
                ],
              ),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 36,
                      child: Card(
                          elevation: 2,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    IconlyLight.user,
                                  ),
                                ),
                                Text(
                                  task.customerName,
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 36,
                      child: Card(
                          elevation: 2,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    IconlyLight.buy,
                                  ),
                                ),
                                Text(
                                  "${task.price.toString()} \$",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp),
                                ),
                              ],
                            ),
                          )),
                    ),
                    const Expanded(child: SizedBox(width: 2,)),
                    IconButton(
                        onPressed: () async => await controller.delete(task.id!),
                        icon: const Icon(
                          IconlyBold.delete,
                          color: Colors.red,
                        )),
                    task.taskStatus == strTaskStatusPending
                        ? ElevatedButton(
                            onPressed: () async =>
                                await markTaskCompleted(context, task),
                            child: const Text('Mark Completed'))
                        : task.taskStatus == strTaskStatusComplete ?
                    ElevatedButton(
                            onPressed: () async {
                              final controller = Get.find<TaskController>();
                              await controller.markTask(
                                  task, strTaskStatusPending, null);
                            },
                            child: const Text('Mark Pending')) :
                    ElevatedButton(
                        onPressed: () async =>
                        await markTaskCompleted(context, task),
                        child: const Text('Mark Completed'))
                    ,


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildTaskChild(
                        theme: theme,
                        title: task.taskStatus ?? '',
                        icon: task.taskStatus == strTaskStatusComplete
                            ? IconlyBold.tick_square
                            : IconlyBold.close_square),
                    buildTaskChild(
                        title: DateFormat('d MMMM').format(
                            DateTime.fromMicrosecondsSinceEpoch(task.dueDate)),
                        icon: IconlyBold.calendar,
                        theme: theme),
                    buildTaskChild(
                        theme: theme,
                        title: 'Shelf Before (${task.shelfBefore})',
                        icon: IconlyBold.category),
                    buildTaskChild(
                        theme: theme,
                        title: 'Shelf After (${task.shelfAfter ?? ''})',
                        icon: IconlyBold.category),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
                  child: Text(
                    task.detail ?? '',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Card buildTaskChild(
      {required ThemeData theme,
      required String title,
      required IconData icon}) {
    return Card(
        elevation: 2,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  icon,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ));
  }

  ShapeBorder getTileShapeWithIndex(int index) {
    switch (index) {
      case 0:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ));
      case -1:
        return const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ));
      default:
        return const RoundedRectangleBorder(borderRadius: BorderRadius.zero);
    }
    ;
  }
}
