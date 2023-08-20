import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/modules/customer/controllers/customer_controller.dart';
import 'package:tailor/app/modules/task/controllers/task_controller.dart';
import '../../../../utils/validators.dart';
import '../../Customer/model/Customers.dart';
import '../../customer/views/create_customer_dialog.dart';
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
  List<String> itemTypes = [
    'Other',
    'Shirt',
    'Pants',
    'Dress',
    'Skirt',
    'Blouse',
    'Jacket',
    'Coat',
    'Suit',
    'Vest',
    'Trousers',
    'Shorts',
    'Tie',
    'Scarf',
  ];

  @override
  void initState() {
    // TODO: implement initState
    controller.refresh();
    taskController.refresh();
    dueDate = DateTime(now.year, now.month, now.day);
    super.initState();
  }

  final TextEditingController _customerPhoneController =
          TextEditingController(),
      _dateController = TextEditingController(),
      _shelBeforeController = TextEditingController(),
      _priceController = TextEditingController(),
      _detailController = TextEditingController();
  final _customerNameFocus = FocusNode(), _priceFocus = FocusNode();
  final GlobalKey<FormState> formKeyTask = GlobalKey<FormState>();

  late Customer selectedCustomer;
  String? selectedItemType; // In
  // itialize with null

  DateTime now = DateTime.now();
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
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
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
        leading: IconButton(
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
                    Column(
                      children: [
                        TextFormField(
                          controller: _customerPhoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          focusNode: _customerNameFocus,
                          inputFormatters: [
                            PhoneNumberFormatter()
                          ], // Attach the focus node
                          decoration: InputDecoration(
                              hintText: 'Customer Phone',
                              hintStyle: context.textTheme.bodySmall),
                          onChanged: (query) => setState(() {}),
                          onEditingComplete: () {
                            _customerNameFocus
                                .unfocus(); // Remove focus from the current field
                          },
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Customer Phone is required';
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
                                .where((customer) => customer.phone!
                                    .contains(_customerPhoneController.text))
                                .toList();

                            print(
                                'filteredCustomers ${filteredCustomers.length}');

                            if (!_customerNameFocus.hasFocus) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _customerPhoneController.text.isEmpty
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
                                              var customer = await Get.dialog(
                                                  CreateCustomerDialog(
                                                      customerPhone:
                                                          _customerPhoneController
                                                              .text));
                                              _customerPhoneController.clear();
                                              if (customer != null) {
                                                selectedCustomer = customer;
                                                _customerPhoneController.text =
                                                    customer.phone;
                                                _customerNameFocus.unfocus();
                                                _priceFocus.requestFocus();
                                              }
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
                                                    _customerPhoneController
                                                            .text =
                                                        filteredCustomers[index]
                                                            .phone!;
                                                    _customerNameFocus
                                                        .unfocus();
                                                    _priceFocus.requestFocus();
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
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Phone: ${filteredCustomers[index].phone ?? ''}",
                                                          style: context
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          "Name: ${filteredCustomers[index].name ?? ''}",
                                                          style: context
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        const Expanded(
                                                          child: SizedBox(
                                                            width: 4,
                                                          ),
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
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _priceController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocus,
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
                            "Select Cloth Type",
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
                    TextFormField(
                      controller: _detailController,
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
                        if (_customerPhoneController.text.isNotEmpty) {
                          MyTask task = MyTask.create(
                            customerPhone: selectedCustomer.phone,
                            customerName: selectedCustomer.name,
                            itemType: selectedItemType ?? '',
                            detail: _detailController.text ?? '',
                            dueDate: dueDate!.microsecondsSinceEpoch,
                            price: double.parse(_priceController.text),
                            customerId: selectedCustomer.id!,
                            shelfBefore: int.parse(_shelBeforeController.text),
                          );
                          await taskController
                              .createTask(task)
                              .then((result) async {
                            if (DateTime.fromMicrosecondsSinceEpoch(
                                    task.dueDate)
                                .isBefore(
                                    DateTime(now.year, now.month, now.day))) {
                              await taskController.refreshDues();
                            }
                          });
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
    _customerPhoneController.dispose();
    super.dispose();
  }
}
