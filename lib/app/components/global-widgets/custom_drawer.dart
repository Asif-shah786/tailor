import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../modules/task/views/task_view.dart';

enum AppPage {
  task,
  // Add more pages here
}

class CustomDrawerController extends GetxController {
  Rx<AppPage> currentPage = AppPage.task.obs;


  Map navigation = {
    AppPage.task : TaskView(),
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

          SizedBox(height: 10,),

          // Menu items
          ListTile(
            leading: Icon(
              controller.currentPage == AppPage.task
                  ? IconlyBold.home
                  : IconlyLight.home,
              color: Colors.white,
            ),
            title: Text('Home'),
            onTap: () {
              controller.changePage(AppPage.task);
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}
