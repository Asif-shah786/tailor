import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../modules/task/controllers/task_controller.dart';
import '../modules/task/model/tasks.dart';

class BuildTaskTiles extends StatefulWidget {
  BuildTaskTiles({super.key, required this.taskList, this.emptyMsg = '', this.callback});
  final List<MyTask> taskList;
  VoidCallback? callback;
  final String emptyMsg;

  @override
  State<BuildTaskTiles> createState() => _BuildTaskTilesState();
}

class _BuildTaskTilesState extends State<BuildTaskTiles> {
  final TaskController controller = Get.find<TaskController>();
  final _shelAfterController = TextEditingController();
  final FocusNode _shelAfterFocus = FocusNode();


@override
  void dispose() {
    // TODO: implement dispose
  _shelAfterFocus.dispose();
  _shelAfterController.dispose();
    super.dispose();
  }

  Future<void> markTaskCompleted(BuildContext context, MyTask task) async {
  _shelAfterFocus.requestFocus();
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: Column(
        children: [
          TextFormField(
            controller: _shelAfterController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // Allows only digits
            focusNode: _shelAfterFocus,
            decoration: InputDecoration(
              hintText: 'Enter After shelf Number',
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
          bool isCompletedLate = task.taskStatus == strTaskStatusComplete &&
              DateTime.fromMicrosecondsSinceEpoch(task.completedDate!).isAfter(
                  DateTime.fromMicrosecondsSinceEpoch(task.dueDate));


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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTaskChild(
                      theme: theme,
                      title: task.customerName,
                      icon: IconlyLight.user),
                  buildTaskChild(
                      theme: theme,
                      title: task.customerPhone,
                      icon: IconlyLight.call),
                  buildTaskChild(
                      theme: theme,
                      title:  "${task.price.toString()} \$",
                      icon: IconlyLight.buy,),
                  buildTaskChildText(
                      value: DateFormat('d MMMM').format(
                          DateTime.fromMicrosecondsSinceEpoch(task.dueDate)),
                      title: 'Due Date ',
                      theme: theme),
                  const Expanded(child: SizedBox(width: 4 ,),),
                  if(isCompletedLate) Text('late', style: context.textTheme.titleSmall!.copyWith(
                      fontStyle: FontStyle.italic,
                      color : Colors.red),),
                  if(overDueTask) const Icon(Icons.watch_later, color: Colors.red,),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.print)),

                ],
              ),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildTaskChild(
                        theme: theme,
                        title: task.taskStatus ?? '',
                        icon: task.taskStatus == strTaskStatusComplete
                            ? IconlyBold.tick_square
                            : IconlyBold.close_square),
                    buildTaskChildText(
                        value: DateFormat('d MMMM').format(
                            DateTime.fromMicrosecondsSinceEpoch(task.createdDate!)),
                        title: 'Created Date',
                        theme: theme),
                    buildTaskChildText(
                        value: task.completedDate == -1 ? 'Nil' : DateFormat('d MMMM').format(
                            DateTime.fromMicrosecondsSinceEpoch(task.completedDate!)),
                        title: 'Completed Date',
                        theme: theme),
                    buildTaskChild(
                        theme: theme,
                        title: 'Shelf Before ${task.shelfBefore == -1 ? 'Nil' : task.shelfBefore}',
                        icon: IconlyBold.category),
                    buildTaskChild(
                        theme: theme,
                        title: 'Shelf After ${task.shelfAfter == -1 ? 'Nil' : task.shelfAfter}',
                        icon: IconlyBold.category),
                    const Expanded(child: SizedBox(width: 1,)),

                    const Expanded(child: SizedBox(width: 2,)),
                    IconButton(
                        onPressed: () async {
                          await controller.deleteWithAlert(task.id!);
                          if(widget.callback != null){
                            widget.callback!();
                          }
                        },
                        icon: const Icon(
                          IconlyBold.delete,
                          color: Colors.red,
                        )),
                    task.taskStatus == strTaskStatusPending
                        ? ElevatedButton(
                        onPressed: () async {
                          await markTaskCompleted(context, task);
                          if(widget.callback != null){
                            widget.callback!();
                          }
                        },
                        child: const Text('Mark Completed'))
                        : task.taskStatus == strTaskStatusComplete ?
                    ElevatedButton(
                        onPressed: () async {
                          final controller = Get.find<TaskController>();
                          await controller.markTask(
                              task, strTaskStatusPending, null);
                          if(widget.callback != null){
                            widget.callback!();
                          }
                        },
                        child: const Text('Mark Pending')) :
                    ElevatedButton(
                        onPressed: () async =>
                        await markTaskCompleted(context, task),
                        child: const Text('Mark Completed'))
                    ,
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

  SizedBox buildTaskChild(
      {required ThemeData theme,
      required String title,
      required IconData icon}) {
    return SizedBox(
      height: 36,
      child: Card(
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
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )),
    );
  }

  SizedBox buildTaskChildText(
      {required ThemeData theme,
        required String title,
        required String value}) {
    return SizedBox(
      height: 36,
      child: Card(
          elevation: 2,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child:       Text(
                    title,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )),
    );
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
