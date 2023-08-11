// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../global-widgets/custom_drawer.dart';


class BottomNavbar extends GetView<CustomDrawerController> {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      drawer: CustomDrawer(),
      body: Obx(() => controller.navigation[controller.currentPage.value]),
    );
  }
}