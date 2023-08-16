import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/modules/customer/controllers/customer_controller.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import '../../Customer/model/Customers.dart';
import '../../customer/views/customer_view.dart';
import '../model/tasks.dart';

class CreateTaskDialog extends StatefulWidget {
  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final controller = Get.find<CustomerController>();
  final taskController = Get.find<TaskController>();

  List<Customer> customers = [];
  List<Customer> searchCustomers = [];
  List<String> itemTypes = ['Item Type 1', 'Item Type 2', 'Item Type 3'];

  @override
  void initState() {
    // TODO: implement initState
    controller.refresh();
    taskController.refresh();
    super.initState();
  }

  final TextEditingController _titleController = TextEditingController(),
      _customerNameController = TextEditingController(),
      _dateController = TextEditingController(),
      _shelBeforeController = TextEditingController(),
      _priceController = TextEditingController(),
      _detailController = TextEditingController();
  final _customerNameFocus = FocusNode(), _descriptionFocus = FocusNode();
  final GlobalKey<FormState> formKeyTask = GlobalKey<FormState>();

  late Customer selectedCustomer;
  String? selectedItemType; // Initialize with null
  String taskHint = "Task title";

  DateTime dueDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                context.theme.primaryColor, // Change the primary color to blue
            colorScheme: ColorScheme.light(
                primary: context
                    .theme.primaryColor), // Change the color scheme to blue
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = DateTime(picked.year, picked.month, picked.day);
        _dateController.text = "${dueDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        leading:           IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Material(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKeyTask,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: taskHint,
                        hintStyle: context.textTheme.bodySmall,
                      ),
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Allows only digits
                      decoration: InputDecoration(
                        hintText: 'Enter Price',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return 'Price is required';
                        }

                        // Additional validation to check if the input is a valid integer
                        if (double.tryParse(text) == null) {
                          return 'Please enter a valid integer';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _shelBeforeController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Allows only digits
                      decoration: InputDecoration(
                        hintText: 'Enter shelf Number',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return 'Shelf Number is required';
                        }

                        // Additional validation to check if the input is a valid integer
                        if (int.tryParse(text) == null) {
                          return 'Please enter a valid integer';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedItemType,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            "Select Item Type",
                            style: context.textTheme.bodySmall,
                          ), // Placeholder text
                        ),
                        ...itemTypes
                            .map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedItemType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _dateController,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: "Pick a date",
                        suffixIcon: Icon(
                          Icons.today,
                          color: context.theme.primaryColor,
                        ),
                        border: const UnderlineInputBorder(),
                        hintStyle: context.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        TextFormField(
                          controller: _customerNameController,
                          textInputAction: TextInputAction.next,
                          focusNode:
                              _customerNameFocus, // Attach the focus node
                          decoration: InputDecoration(
                              hintText: 'Customer Name',
                              hintStyle: context.textTheme.bodySmall),
                          onChanged: (query) => setState(() {}),
                          onEditingComplete: () {
                            _customerNameFocus
                                .unfocus(); // Remove focus from the current field
                          },
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Customer Name is required';
                            }
                            return null;
                          },
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

                            if (!_customerNameFocus.hasFocus) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _customerNameController.text.isEmpty
                                    ? const SizedBox.shrink()
                                    : filteredCustomers.isEmpty
                                        ? ListTile(
                                            minVerticalPadding: 0,
                                            minLeadingWidth: 0,
                                            title: Text(
                                              'Customer not found, Click to add New Customer (+)',
                                              textAlign: TextAlign.start,
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            trailing: Icon(
                                              IconlyBold.plus,
                                              color: context.iconColor,
                                            ),
                                            dense: true,
                                            onTap: () async {
                                              _customerNameController.clear();
                                              Get.dialog(
                                                  const CreateCustomerDialog());
                                            },
                                          ) // Loading indicator
                                        : Container(
                                            height: 100,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: ListView.separated(
                                              separatorBuilder: (_, index) =>
                                                  Divider(
                                                      height: 0.5,
                                                      color: context
                                                          .theme.dividerColor),
                                              itemCount:
                                                  filteredCustomers.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    // Select suggestion
                                                    selectedCustomer =
                                                        filteredCustomers[
                                                            index];
                                                    _customerNameController
                                                            .text =
                                                        filteredCustomers[index]
                                                            .name;
                                                    _customerNameFocus
                                                        .unfocus();
                                                    _descriptionFocus
                                                        .requestFocus();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height:
                                                        30, // Adjust the height as needed
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          filteredCustomers[
                                                                  index]
                                                              .name,
                                                          style: context
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          'Select',
                                                          style: context
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  color: context
                                                                      .theme
                                                                      .primaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _detailController,
                      focusNode: _descriptionFocus,
                      minLines: 5, // Set the minimum number of lines
                      maxLines: 5, // Set the maximum number of lines
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.grey[200], // Choose your desired color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'You can write task details here',
                        hintStyle: context.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Create task logic
                        if (!formKeyTask.currentState!.validate()) {
                          return;
                        }
                        if (_customerNameController.text.isNotEmpty &&
                            _titleController.text.isNotEmpty) {
                          MyTask task = MyTask.create(
                            customerName: selectedCustomer.name,
                            title: _titleController.text,
                            itemType: selectedItemType ?? '',
                            detail: _detailController.text ?? '',
                            dueDate: dueDate!.microsecondsSinceEpoch,
                            price: double.parse(_priceController.text),
                            customerId: selectedCustomer.id!,
                            shelfBefore: int.parse(_shelBeforeController.text),
                          );

                          await taskController.createTask(task);
                        }
                        Get.back(); // Close the dialog
                      },
                      child: const Text('Create Task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
