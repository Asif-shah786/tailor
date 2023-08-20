import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/customers_db.dart';
import '../../Customer/model/Customers.dart';

class CustomerController extends GetxController {
  //TODO: Implement CustomerController

  final StreamController<List<Customer>> _customerController =
      StreamController<List<Customer>>.broadcast();

  Stream<List<Customer>> get customers => _customerController!.stream;
  late CustomerDB _customerDB;
  final customerPhoneController = TextEditingController();
  final customerNameFocus = FocusNode();

  @override
  void onInit() {
    // TODO: implement onInit
    _customerDB = CustomerDB.get();
    refresh();
    super.onInit();
  }

  @override
  void dispose() {
    _customerController.close();
  }

  void _loadCustomers() {
    _customerDB.getCustomers().then((projects) {
      print('Projects Length');
      print(projects.length);
      if (!_customerController.isClosed) {
        _customerController.sink.add(projects);
      }
    });
  }

  Future<void> createCustomer(Customer customer) async {
    await _customerDB.insertOrReplace(customer).then((value) {
      _loadCustomers();
    });
  }

  Future<void> delete(Customer customer) async {
    await _customerDB.delete(customer).then((value) {
      _loadCustomers();
    });
  }

  Future<void> deleteWithAlert(Customer customer) async {
    // Show an AlertDialog to confirm the deletion
    bool? confirmDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text('Are you sure you want to delete this customer and related tasks?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.primaryColor,
            ),
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.primaryColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await delete(customer);
    }
    Get.back();
  }


  void refresh() {
    _loadCustomers();
  }
}
