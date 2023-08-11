import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor/app/modules/customer/controllers/customer_controller.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';

import '../../Customer/model/Customers.dart';
import '../model/Tasks.dart';

class CreateTaskDialog extends StatefulWidget {
  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final controller = Get.find<CustomerController>();
  final taskController = Get.find<TaskController>();

  List<Customer> customers = [];
  List<Customer> searchCustomers = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();

  late Customer selectedCustomer;

  String taskHint = "Task title";

  @override
  Widget build(BuildContext context) {
    controller.refresh();
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                constraints: BoxConstraints.expand(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 100),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: taskHint),
                    ),
                    const SizedBox(height: 10),
                    // Use a StreamBuilder to display customer search results
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _customerNameController,
                                  decoration: const InputDecoration(
                                      hintText: 'Customer Name'),
                                  onChanged: (query) => setState(() {
                                    controller.refresh();
                                  }),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_customerNameController.text.isNotEmpty) {
                                    // Create a new customer with the entered name
                                    Customer newCustomer = Customer.create(
                                        name: _customerNameController.text);

                                    // Call the createCustomer method to store the new customer in the database
                                    controller.createCustomer(newCustomer);

                                    // Clear the customer name field
                                    _customerNameController.clear();

                                    // Show a success message
                                    Get.snackbar('Success',
                                        'Customer added to the database',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white);
                                  } else {
                                    // Show an error message if either the task title or customer name is empty
                                    Get.snackbar('Error',
                                        'Please enter both task title and customer name',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white);
                                  }
                                  setState(() {});
                                },
                                child: Text('Add New'),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<List<Customer>>(
                          stream: controller.customers,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox
                                  .shrink(); // Loading indicator
                            }
                            final filteredCustomers = snapshot.data!
                                .where((customer) => customer.name
                                    .toLowerCase()
                                    .contains(_customerNameController.text
                                        .toLowerCase()))
                                .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                filteredCustomers.isNotEmpty
                                    ? Text(
                                        'customer not found',
                                        textAlign: TextAlign.start,
                                        style: context.textTheme.bodySmall,
                                      ) // Loading indicator
                                    : Container(
                                        height: 100,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ListView.builder(
                                          itemCount: filteredCustomers.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              minVerticalPadding: 0,
                                              textColor: context.theme.canvasColor,
                                              title: Text(
                                                  filteredCustomers[index]
                                                      .name),
                                              trailing: Text('select', style: context.textTheme.titleSmall,),
                                              onTap: () {
                                                // Select suggestion
                                                selectedCustomer = filteredCustomers[index];
                                                _customerNameController.text =
                                                    filteredCustomers[index]
                                                        .name;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Create task logic
                        if (_customerNameController.text.isNotEmpty  && _titleController.text.isNotEmpty) {

                          MyTask task = MyTask.create(
                            title: _titleController.text, itemType: '',
                            customerId: '',

                          );

                          taskController.createTask(task);
                        }
                        Get.back(); // Close the dialog
                      },
                      child: Text('Create Task'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }
}
