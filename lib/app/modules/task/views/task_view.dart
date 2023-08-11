import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/modules/customer/controllers/customer_controller.dart';
import 'package:tailor/app/modules/customer/views/customer_view.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import 'package:tailor/app/modules/task/views/creat_task_dialog.dart';

import '../../../../config/theme/my_fonts.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../../../components/empty_widget.dart';
import '../../../routes/app_pages.dart';
import '../../Customer/model/Customers.dart';

class TaskView extends GetView<TaskController> {
  TaskView({Key? key}) : super(key: key);

  final CustomerController customerController = Get.put(CustomerController());

  void showCreateTask() {

    Get.dialog(CreateTaskDialog());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
                onPressed: () async {

                  showCreateTask();
                },
                icon: const Icon(
                  IconlyBold.plus,
                  color: Colors.white,
                )),
          ],
          centerTitle: true,
        ),
        body: StreamBuilder<List<Customer>>(
          stream: customerController.customers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProjectExpansionTileWidget(snapshot.data!);
            } else {
              return Center(
                child: ElevatedButton(onPressed: (){
                  Get.toNamed(AppPages.Customer);
                },child: Text('Go Customer'),),
              );
            }
          },
        )
      // body: Obx(() =>
      // controller.isError.value == true
      //     ? EmptyWidget(onPressed: () async => await controller.getPostList())
      //     : RefreshIndicator(
      //   color: theme.primaryColor,
      //   onRefresh: () async => await controller.getPostList(),
      //   child: Padding(
      //     padding: const EdgeInsets.all(18.0),
      //     child: RawScrollbar(
      //       thumbColor: theme.primaryColor,
      //       radius: const Radius.circular(100),
      //       thickness: 5,
      //       interactive: true,
      //       child: ListView.separated(
      //         itemCount: controller.postList.length,
      //         physics: const BouncingScrollPhysics(),
      //         padding: EdgeInsets.zero,
      //         separatorBuilder: (_, __) =>
      //             SizedBox(
      //               height: 20.h,
      //             ),
      //         itemBuilder: (ctx, index) =>
      //             GestureDetector(
      //               onTap: () async {
      //                 await controller
      //                     .getPostDetail(controller.postList[index].id);
      //               },
      //               child: Container(
      //                 padding: const EdgeInsets.all(5),
      //                 width: double.infinity,
      //                 color: theme.canvasColor,
      //                 child: Center(
      //                   child: Text(
      //                     controller.postList[index].title ?? "",
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                       fontSize: MyFonts.headline6TextSize,
      //                       fontWeight: FontWeight.w500,
      //                       color: theme.primaryColor,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //       ),
      //     ),
      //   ),
      // )),
    );
  }
}

class ProjectExpansionTileWidget extends StatelessWidget {
  final List<Customer> _projects;

  ProjectExpansionTileWidget(this._projects);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey('drawerTasks'),
      leading: Icon(Icons.book),
      title: Text("Projects",
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
      children: buildProjects(context),
    );
  }

  List<Widget> buildProjects(BuildContext context) {
    final controller = Get.find<CustomerController>();
    List<Widget> projectWidgetList = [];
    _projects.forEach((project) => projectWidgetList.add(Text(project.name)));
    projectWidgetList.add(ListTile(
      key: ValueKey('drawerAddProject'),
      leading: Icon(Icons.add),
      title: Text("Add Project"),
      onTap: () async {
        print('Refresh Clicked');
        var project = Customer.create(
            name : 'Ali',
            address: 'Ghazi'
        );
        controller.createCustomer(project);
      },
    ));
    return projectWidgetList;
  }
}