import 'package:sqflite/sqflite.dart';

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
    var result = await db.rawQuery('SELECT * FROM ${Customer.tblCustomer}');
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
          'INSERT OR REPLACE INTO '
          '${Customer.tblCustomer}(${Customer.dbName},${Customer.dbPhone},${Customer.dbAddress},${Customer.dbCreatedDate})'
          ' VALUES(?,?,?,?)',
          [
            "${customer.name}",
            "${customer.phone}",
            "${customer.address}",
            "${customer.createdDate}"
          ]);
    });

    List<Customer> list2 = await getCustomers();
    print('Customers List : ${list2.length}');
  }

  Future deleteCustomer(int CustomerID) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${Customer.tblCustomer} WHERE ${Customer.dbId}==$CustomerID;');
    });
  }
}
