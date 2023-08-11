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
  late bool isInboxVisible;

  @override
  void onInit() {
    // TODO: implement onInit
    _customerDB = CustomerDB.get();
    isInboxVisible = true;
    super.onInit();
  }

  @override
  void dispose() {
    _customerController.close();
  }

  void _loadCustomers(bool isInboxVisible) {
    _customerDB.getCustomers().then((projects) {
      print('Projects Length');
      print(projects.length);
      if (!_customerController.isClosed) {
        _customerController.sink.add(projects);
      }
    });
  }

  void createCustomer(Customer customer) {
    _customerDB.insertOrReplace(customer).then((value) {
      if (value == null) {
        Get.snackbar('Error', 'Failed to add customer',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      _loadCustomers(isInboxVisible);
    });
  }


  void refresh() {
    _loadCustomers(isInboxVisible);
  }
}
