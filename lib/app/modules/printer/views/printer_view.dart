import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/global-widgets/custom_drawer.dart';
import '../controllers/printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  const PrinterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer'),
      ),
      drawer: CustomDrawer(),
      body: const Center(
        child: Text(
          'Hold on, This feature is coming soon!!!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
