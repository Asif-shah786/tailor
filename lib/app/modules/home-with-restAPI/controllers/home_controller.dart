import 'package:get/get.dart';

import '../../../components/navbar/navbar_controller.dart';
import '../../../service/REST/api_urls.dart';
import '../../../service/REST/dio_client.dart';
import '../../../service/handler/exception_handler.dart';
import '../bindings/home_binding.dart';
import '../model/posts.dart';
import '../views/post_detail_view.dart';

class HomeController extends GetxController with ExceptionHandler {
  final navController = Get.put(NavbarController());

  ///GET POST LIST
  final postList = RxList<Posts>();

  getPostList() async {
    showLoading();

    var response =
        await DioClient().get(url: ApiUrl.allPosts).catchError(handleError);

    if (response == null) return;

    postList
        .assignAll((response as List).map((e) => Posts.fromJson(e)).toList());

    hideLoading();
  }

  /// GET POST DETAIL
  String title = "";
  String body = "";

  getPostDetail(int? id) async {
    showLoading();
    var response = await DioClient()
        .get(url: "${ApiUrl.postDetail}$id")
        .catchError(handleError);

    if (response == null) return;

    title = response["title"].toString();
    body = response["body"].toString();
    hideLoading();
    Get.to(() => const PostDetailView(), binding: HomeBinding());
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    await getPostList();

    super.onReady();
  }
}