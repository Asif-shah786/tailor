import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/components/empty_widget.dart';
import 'package:tailor/app/modules/Customer/model/Customers.dart';
import '../../../../utils/validators.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../controllers/customer_controller.dart';
import 'create_customer_dialog.dart';
import 'customer_task_view.dart';

class CustomerView extends GetView<CustomerController> {



  @override
  Widget build(BuildContext context) {
    controller.refresh();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog( const CreateCustomerDialog(customerPhone: '',));
              },
              icon: const Icon(
                IconlyBold.plus,
                color: Colors.white,
              )),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.customerPhoneController,
                    focusNode: controller.customerNameFocus, // Attach the focus node
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: context.textTheme.titleMedium!.copyWith(color: Colors.grey),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 16), // Adjust this padding as needed
                        child: Icon(
                          IconlyLight.search,
                          size: 26,
                          color: context.iconColor,
                        ),
                      ),),
                    onChanged: (value) {
                      controller.update();
                    },
                    onEditingComplete: () {
                      controller.customerNameFocus
                          .unfocus(); // Remove focus from the current field
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    controller.customerPhoneController.clear();
                    controller.customerNameFocus.unfocus();
                  },
                  child: Text('Clear Search',style: context.textTheme.titleSmall!.copyWith(
                      color: Colors.white),),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: StreamBuilder<List<Customer>>(
                  stream: controller.customers,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink(); // Loading indicator
                    }
                    final customers = snapshot.data!
                        .where((customer) => customer.phone!
                        .contains(controller.customerPhoneController.text
                        .toLowerCase()) || customer.name.toLowerCase().contains(controller.customerPhoneController.text.toLowerCase()))
                        .toList();

                    if (customers.isEmpty) {
                      EmptyWidget(
                        onPressed: () {},
                      );
                    }
                    final theme = Theme.of(context);
                    return ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (BuildContext context, int index) {
                        Customer customer = customers[index];
                        return Card(
                            elevation: 2,
                            color: theme.cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      IconlyLight.user,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    customer.name,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 4,),
                                  Text(
                                    customer.phone!,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const Expanded(
                                      child: SizedBox(
                                        width: 1,
                                      )),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await controller
                                                .deleteWithAlert(customer);
                                          },
                                          icon: const Icon(
                                            IconlyBold.delete,
                                            color: Colors.red,
                                          )),
                                      ElevatedButton(
                                          onPressed: () {
                                            Get.to(() => CustomerTaskView(customerId : customer.id!, name : customer.name));
                                          },
                                          child: const Text(
                                              'View Tasks')),
                                    ],
                                  )
                                ],
                              ),
                            ));
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      // Add more UI components here if needed
    );
  }
}

