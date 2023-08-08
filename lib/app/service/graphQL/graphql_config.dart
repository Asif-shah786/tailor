import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httpLink =
      HttpLink("https://api.mocki.io/v2/c4d7a195/graphql");

  final AuthLink authLink = AuthLink(
      getToken: () async {
        //  String token = await MySharedPref.getToken() ?? "";
        //  return "JWT $token";
        return "JWT token";
      },
      headerKey: "Authorization");

  GraphQLClient graphqlClient() => GraphQLClient(
        cache: GraphQLCache(),
        link: authLink.concat(httpLink),
      );
}
