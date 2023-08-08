import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../../config/theme/my_fonts.dart';
import '../../../components/empty_widget.dart';
import '../controllers/graphql_controller.dart';

class GraphQLView extends GetView<GraphQLController> {
  const GraphQLView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL'),
        actions: [
          IconButton(
              onPressed: () => controller.navController.selectedIndex.value = 0,
              icon: const Icon(
                IconlyBold.home,
                color: Colors.white,
              )),
        ],
        centerTitle: true,
      ),
      body: Obx(() =>
      controller.isError.value == true
          ? EmptyWidget(onPressed: () async => await controller.getAlbums())
          : RefreshIndicator(
        color: theme.primaryColor,
        onRefresh: () async => await controller.getAlbums(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: RawScrollbar(
            thumbColor: theme.primaryColor,
            radius: const Radius.circular(100),
            thickness: 5,
            interactive: true,
            child: Column(
              children: [
                SizedBox(
                  width: 150.w,
                  child: ElevatedButton(
                      onPressed: () async {
                        await controller.updateTodo();
                      },
                      child: const Text("Run mutation")),
                ),
                SizedBox(height: 10.h),
                controller.mutationResult.isEmpty
                    ? const SizedBox()
                    : Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                      "RESULT :${controller.mutationResult.value}"),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.userList.length,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    separatorBuilder: (_, __) =>
                        SizedBox(
                          height: 20.h,
                        ),
                    itemBuilder: (ctx, index) =>
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          color: theme.canvasColor,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      theme.primaryColor.withOpacity(.3),
                                      blurRadius: 7.0,
                                      spreadRadius: 4,
                                      offset: const Offset(0, 3),
                                    )
                                  ]),
                              child: Center(
                                child: Text(
                                  controller.userList[index]["name"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: MyFonts.headline6TextSize,
                                    fontWeight: FontWeight.w500,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}