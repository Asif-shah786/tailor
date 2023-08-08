import 'package:get/get.dart';

import '../../modules/home-with-graphql/views/graphql_view.dart';
import '../../modules/home-with-restAPI/views/home_view.dart';

class NavbarController extends GetxController {
  List navigation = [
    const HomeView(),
    const GraphQLView(),
  ];
  RxInt selectedIndex = 0.obs;

  void onTap(int index) {
    selectedIndex.value = index;
  }
}