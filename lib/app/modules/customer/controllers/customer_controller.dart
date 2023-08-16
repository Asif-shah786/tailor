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
  RxBool showSearch = false.obs;

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


  void refresh() {
    _loadCustomers();
  }
}
