class MyTask {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbDetail = "detail";
  static final dbItemType = "item_type";
  static final dbDueDate = "due_date";
  static final dbCreatedDate = "created_date";
  static final dbCompletedDate = "completed_date";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbShelfBefore = "shelf_before";
  static final dbShelfAfter = "shelf_After";
  static final dbCustomerName = "customer_name";
  static final dbCustomerPhone = "customer_phone";
  static final dbCustomerId = "customer_id";
  static final dbPrice = "price";

  String itemType, customerName, customerPhone;
  String? detail;
  int? id;
  int dueDate, customerId, shelfBefore, completedDate, createdDate, shelfAfter;
  double price;
  String? taskPriority, taskStatus;

  MyTask.create({
    required this.itemType,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.shelfBefore,
    required this.price,
    this.taskStatus = 'PENDING',
    this.shelfAfter = -1,
    this.detail = "",
    this.dueDate = -1,
    this.createdDate = -1,
    this.completedDate = -1,
    this.taskPriority = 'PRIORITY_3',
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().microsecondsSinceEpoch;
    }
  }

  bool operator ==(o) => o is MyTask && o.id == id;

  MyTask.update({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.shelfBefore,
    required this.itemType,
    required this.price,
    this.taskStatus = 'PENDING',
    this.detail = "",
    this.shelfAfter = -1,
    this.completedDate = -1,
    this.dueDate = -1,
    this.createdDate = -1,
    this.taskPriority = 'PRIORITY_3',
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().microsecondsSinceEpoch;
    }
  }

  MyTask.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          customerName: map[dbCustomerName],
          shelfBefore: map[dbShelfBefore],
          customerId: map[dbCustomerId] ?? 0,
          customerPhone: map[dbCustomerPhone],
          itemType: map[dbItemType],
          detail: map[dbDetail],
          completedDate: map[dbCompletedDate] ?? -1,
          shelfAfter: map[dbShelfAfter] ?? -1,
          dueDate: map[dbDueDate],
          createdDate: map[dbCreatedDate],
          taskPriority: map[dbPriority],
          taskStatus: map[dbStatus],
          price: map[dbPrice],
        );
}

String strTaskStatusPending = 'PENDING';
String strTaskStatusComplete = 'COMPLETED';
String strTaskStatusOverDue = 'OVERDUE';

String strTaskPriority1 = 'priority_1';
String strTaskPriority2 = 'priority_2';
String strTaskPriority3 = 'priority_3';


enum TaskStatus {
  PENDING,
  COMPLETE,
  OVERDUE,
}
enum TaskPriority{
  PRIORITY_1,
  PRIORITY_2,
  PRIORITY_3,
}