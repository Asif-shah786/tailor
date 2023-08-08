import 'package:get/get.dart';

import '../components/navbar/bottom_navbar.dart';
import '../components/navbar/navbar_binding.dart';
import '../modules/home-with-graphql/bindings/graphql_binding.dart';
import '../modules/home-with-graphql/views/graphql_view.dart';
import '../modules/home-with-restAPI/bindings/home_binding.dart';
import '../modules/home-with-restAPI/views/home_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const NAV = Routes.NAV;
  static const HOME = Routes.HOME;

  static final routes = [
    /// NAV BAR
    GetPage(
      name: _Paths.NAV,
      page: () => const BottomNavbar(),
      binding: NavbarBinding(),
    ),

    ///
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GRAPHQL,
      page: () => const GraphQLView(),
      binding: GraphQLBinding(),
    ),
  ];
}