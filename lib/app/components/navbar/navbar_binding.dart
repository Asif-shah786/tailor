import 'package:get/get.dart';
import 'package:tailor/app/components/global-widgets/custom_drawer.dart';
import 'package:tailor/app/modules/explore/controllers/explore_controller.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import '../../modules/customer/controllers/customer_controller.dart';
import 'navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDrawerController>(
          () => CustomDrawerController(),
    );
    Get.lazyPut<TaskController>(
      () => TaskController(),
    );
    Get.lazyPut<CustomerController>(
          () => CustomerController(),
    );
    Get.lazyPut<ExploreController>(
          () => ExploreController(),
    );
  }
}