import 'package:sqflite/sqflite.dart';
import 'package:tailor/app/modules/task/model/tasks.dart';

import '../../modules/Customer/model/Customers.dart';
import 'app_db.dart';

class CustomerDB {
  static final CustomerDB _customerDb = CustomerDB._internal(AppDatabase.get());

  final AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  CustomerDB._internal(this._appDatabase);

  static CustomerDB get() {
    print('CustomerDB get Called');
    return _customerDb;
  }

  Future<List<Customer>> getCustomers() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${Customer.tblCustomer}'
        '  ORDER BY ${Customer.dbName} ASC');
    List<Customer> customers = [];
    for (Map<String, dynamic> item in result) {
      var myCustomer = Customer.fromMap(item);
      customers.add(myCustomer);
    }
    return customers;
  }

  Future insertOrReplace(Customer customer) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert(
          'INSERT INTO '
          '${Customer.tblCustomer}(${Customer.dbName},${Customer.dbPhone},${Customer.dbAddress},${Customer.dbCreatedDate})'
          ' VALUES(?,?,?,?)',
          [
            "${customer.name}",
            "${customer.phone}",
            "${customer.address}",
            "${customer.createdDate}"
          ]);
    });
  }

  Future delete (Customer customer) async {
    var db = await _appDatabase.getDb();
    await db.transaction((txn) async {
      await txn.rawDelete(
        'DELETE FROM ${Customer.tblCustomer} WHERE  id = ?',[
          customer.id
      ]
      );
      await txn.rawDelete(
          'DELETE FROM ${MyTask.tblTask} WHERE  customer_id = ?',[
        customer.id
      ]
      );
    });
  }

}
