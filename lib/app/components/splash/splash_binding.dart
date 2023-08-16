import 'package:get/get.dart';
import 'package:tailor/app/components/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}