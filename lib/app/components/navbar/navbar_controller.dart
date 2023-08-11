import 'package:get/get.dart';
import 'package:tailor/app/components/global-widgets/custom_drawer.dart';
import 'package:tailor/app/modules/task/views/task_view.dart';

class NavbarController extends GetxController {

  final controller = Get.find<CustomDrawerController>();

  List navigation = [
    TaskView(),
  ];
  RxInt selectedIndex = 0.obs;

  void onTap(int index) {
    selectedIndex.value = index;
  }
}