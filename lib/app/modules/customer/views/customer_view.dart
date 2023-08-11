import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor/app/modules/Customer/model/Customers.dart';
import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: StreamBuilder(
        stream: controller.customers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.address ?? ''),
                  // You can add more UI components here
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading customers'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Customer customer1 = Customer.create(name: 'John Doe', address: '123 Main St', phone: '123-456-7890');
           controller.createCustomer(customer1);
        },
      ),
      // Add more UI components here if needed
    );
  }
}
