import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/modules/customer/views/customer_view.dart';
import 'package:tailor/app/modules/explore/views/explore_view.dart';
import '../../modules/printer/views/printer_view.dart';
import '../../modules/task/views/task_view.dart';

enum AppPage {
  task,
  customer,
  explore,
  printer,
  // Add more pages here
}

class CustomDrawerController extends GetxController {
  Rx<AppPage> currentPage = AppPage.task.obs;

  Map navigation = {
    AppPage.task : TaskView(),
    AppPage.customer : CustomerView(),
    AppPage.explore : ExploreView(),
    AppPage.printer : const PrinterView(),


  };

  void changePage(AppPage page) {
    currentPage.value = page;
  }
}



class CustomDrawer extends StatelessWidget {
  final CustomDrawerController controller = Get.find();

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.cardColor,
      child: Column(
        children: [
          // Drawer header or user info

          const SizedBox(height: 10,),

          // Menu items
          ListTile(
            leading: Icon(
              controller.currentPage == AppPage.task
                  ? IconlyBold.home
                  : IconlyLight.home,
            ),
            title: const Text('Today'),
            onTap: () {
              controller.changePage(AppPage.task);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              controller.currentPage == AppPage.customer
                  ? IconlyBold.user_3
                  : IconlyLight.user_1,
            ),
            title: const Text('Customers'),
            onTap: () {
              controller.changePage(AppPage.customer);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              controller.currentPage == AppPage.explore
                  ? IconlyBold.activity
                  : IconlyLight.activity,
            ),
            title: const Text('Explore'),
            onTap: () {
              controller.changePage(AppPage.explore);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              controller.currentPage == AppPage.printer
                  ? IconlyBold.scan
                  : IconlyLight.scan,
            ),
            title: const Text('Printer'),
            onTap: () {
              controller.changePage(AppPage.printer);
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}
