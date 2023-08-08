class Customer {
  static const tblCustomer = "Customers";
  static const dbId = "id";
  static const dbName = "name";
  static const dbPhone = "phone";
  static const dbAddress = "address";
  static const dbCreatedDate = "created_date";

  String name;
  String? phone, address, id;
  int? createdDate;

  Customer.create({
    required this.name,
    this.address = '',
    this.phone = '',
    this.createdDate = -1,
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  bool operator ==(o) => o is Customer && o.id == id;

  Customer.update({
    required this.id,
    required this.name,
    this.address = '',
    this.phone = '',
    this.createdDate = -1,
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Customer.fromMap(Map<String, dynamic> map)
      : this.update(
            id: map[dbId],
            name: map[dbName],
            address: map[dbAddress],
            phone: map[dbPhone],
            createdDate: map[dbCreatedDate]);
}
