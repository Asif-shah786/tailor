import 'package:get/get.dart';

import '../../data/local/tasks_db.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  late TaskDB _taskDB;

  @override
  void onInit() {
    print('in init');
    _taskDB = TaskDB.get();
    start();
    super.onInit();
  }

  start () async {
    await Future.delayed(const Duration(milliseconds: 2500));
    print('Before mark due ');
    print(await _taskDB.markTaskOverDue());
    print('After mark due ');
    Get.offAllNamed(AppPages.NAV); // Navigate after the delay
  }

  @override
  void onClose() {
    super.onClose();
  }

}
