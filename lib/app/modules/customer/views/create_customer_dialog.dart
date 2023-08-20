import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:tailor/app/components/empty_widget.dart';
import 'package:tailor/app/modules/Customer/model/Customers.dart';
import '../../../../utils/validators.dart';
import '../../../components/global-widgets/custom_drawer.dart';
import '../controllers/customer_controller.dart';
import 'customer_task_view.dart';


class CreateCustomerDialog extends StatefulWidget {
  const CreateCustomerDialog({
    super.key, required this.customerPhone,
  });

  final String customerPhone;

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
  void initState() {
    // TODO: implement initState
    _phoneNumberController.text = widget.customerPhone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(result: null),
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
                          controller: _phoneNumberController,
                          inputFormatters: [PhoneNumberFormatter()],// Attach the focus node
                          decoration: InputDecoration(
                              hintText: 'Enter Customer Phone',
                              hintStyle: context.textTheme.bodySmall),
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Customer Phone is required';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _addCustomerNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Customer Name',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
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
                              Get.back(result: customer);
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
