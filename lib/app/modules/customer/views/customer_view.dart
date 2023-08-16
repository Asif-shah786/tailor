import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/components/empty_widget.dart';
import 'package:tailor/app/modules/Customer/model/Customers.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../controllers/customer_controller.dart';
import 'customer_task_view.dart';

class CustomerView extends GetView<CustomerController> {
  final _customerNameController = TextEditingController();
  final _customerNameFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    controller.refresh();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(const CreateCustomerDialog());
              },
              icon: const Icon(
                IconlyBold.plus,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                controller.showSearch.value = !controller.showSearch.value;
              },
              icon: const Icon(
                IconlyBold.search,
              )),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Obx(() => Column(
          children: [
            if (controller.showSearch.value)
              TextFormField(
                controller: _customerNameController,
                focusNode: _customerNameFocus, // Attach the focus node
                decoration: InputDecoration(
                    hintText: 'Customer Name',
                    hintStyle: context.textTheme.bodySmall),
                onChanged: (value) {
                  controller.update();
                },
                onEditingComplete: () {
                  _customerNameFocus
                      .unfocus(); // Remove focus from the current field
                },
              ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<List<Customer>>(
                  stream: controller.customers,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink(); // Loading indicator
                    }
                    final customers = snapshot.data!
                        .where((customer) => customer.name
                            .toLowerCase()
                            .contains(_customerNameController.text
                                .toLowerCase()))
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
                                  const Expanded(
                                      child: SizedBox(
                                    width: 1,
                                  )),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await controller
                                                .delete(customer);
                                          },
                                          icon: const Icon(
                                            IconlyBold.delete,
                                            color: Colors.red,
                                          )),
                                      ElevatedButton(
                                          onPressed: () {
                                            Get.to(CustomerTaskView(customerId : customer.id!, name : customer.name));
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
        )),
      ),
      // Add more UI components here if needed
    );
  }
}

class CreateCustomerDialog extends StatefulWidget {
  const CreateCustomerDialog({
    super.key,
  });

  @override
  State<CreateCustomerDialog> createState() => _CreateCustomerDialogState();
}

class _CreateCustomerDialogState extends State<CreateCustomerDialog> {
  final TextEditingController _addCustomerNameController =
          TextEditingController(),
      _phoneNumberController = TextEditingController();
  final CustomerController customerController = Get.find<CustomerController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addCustomerNameController.dispose();_phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                constraints: const BoxConstraints.expand(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _addCustomerNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter customer name',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // Create task logic
                            if (formKey.currentState!.validate()) {
                              Customer customer = Customer.create(
                                name: _addCustomerNameController.text,
                                phone: _phoneNumberController.text,
                              );
                              await customerController.createCustomer(customer);
                              _addCustomerNameController.clear();
                              Get.back();
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
