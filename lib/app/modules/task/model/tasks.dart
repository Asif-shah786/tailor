class MyTask {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbDetail = "detail";
  static final dbItemType = "item_type";
  static final dbDueDate = "due_date";
  static final dbCreatedDate = "created_date";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbShelfBefore = "shelf_before";
  static final dbShelfAfter = "shelf_After";
  static final dbCustomerName = "customer_name";
  static final dbCustomerId = "customer_id";
  static final dbPrice = "price";

  String title, itemType, customerName;
  String? detail;
  int? id, createdDate, shelfAfter;
  int dueDate, customerId, shelfBefore;
  double price;
  String? taskPriority, taskStatus;

  MyTask.create({
    required this.title,
    required this.itemType,
    required this.customerId,
    required this.customerName,
    required this.shelfBefore,
    required this.price,
    this.taskStatus = 'PENDING',
    this.shelfAfter = -1,
    this.detail = "",
    this.dueDate = -1,
    this.createdDate = -1,
    this.taskPriority = 'PRIORITY_3',
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  bool operator ==(o) => o is MyTask && o.id == id;

  MyTask.update({
    required this.id,
    required this.title,
    required this.customerId,
    required this.customerName,
    required this.shelfBefore,
    required this.itemType,
    required this.price,
    this.taskStatus = 'PENDING',
    this.detail = "",
    this.shelfAfter = -1,
    this.dueDate = -1,
    this.createdDate = -1,
    this.taskPriority = 'PRIORITY_3',
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  MyTask.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          customerName: map[dbCustomerName],
          title: map[dbTitle],
          shelfBefore: map[dbShelfBefore],
          customerId: map[dbCustomerId],
          itemType: map[dbItemType],
          detail: map[dbDetail],
          shelfAfter: map[dbShelfAfter],
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