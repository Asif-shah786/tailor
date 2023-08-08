import 'package:get/get.dart';
import 'package:tailor/app/service/handler/exception_handler.dart';

import '../../../components/navbar/navbar_controller.dart';

class GraphQLController extends GetxController with ExceptionHandler {
  final navController = Get.put(NavbarController());
  final userList = RxList<dynamic>();
  RxString mutationResult = "".obs;

  /////////////////////   QUERY /////////////////////////

  Future<void> getAlbums() async {
    showLoading();
    // Build your query string
    const query = """
    query Query{
  users{
    id
    name
    email
    todos{
      description
    }
  }
 
}
    """;

    final result =
    await graphQLService.performQuery(query).catchError(handleGraphqlError);
    if (result == null) return;
    userList.value = List.from(result["users"]);
    hideLoading();
  }

  ////////////////////////  MUTATION   ///////////////////////////

  Future<void> updateTodo() async {
    showLoading();

    const mutation = '''
        mutation {
          updateTodo(input:{id:"Hello World",description:"Hello World"}){
            id
            description
            done
        }
      }
      ''';

    final result = await graphQLService
        .performMutation(mutation)
        .catchError(handleGraphqlError);
    if (result == null) return;
    mutationResult.value = result.toString();
    hideLoading();
  }

  ///

  @override
  void onReady() async {
    await getAlbums();

    super.onReady();
  }
}