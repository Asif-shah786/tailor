import 'package:get/get.dart';

import '../controllers/graphql_controller.dart';

class GraphQLBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphQLController>(
      () => GraphQLController(),
    );
  }
}
