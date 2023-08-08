class Task {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbDetail = "detail";
  static final dbItemType = "item_type";
  static final dbDueDate = "due_date";
  static final dbCreatedDate = "created_date";
  static final dbPriority = "priority";
  static final dbStatus = "status";
  static final dbCustomerId = "customer_id";

  String title, itemType, customerId;
  String? detail;
  int? id, createdDate;
  int dueDate;
  TaskPriority taskPriority;
  TaskStatus? taskStatus;

  Task.create({
    required this.title,
    required this.itemType,
    required this.customerId,
    this.taskStatus = TaskStatus.PENDING,
    this.detail = "",
    this.dueDate = -1,
    this.createdDate = -1,
    this.taskPriority = TaskPriority.PRIORITY_3,
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  bool operator ==(o) => o is Task && o.id == id;

  Task.update({
    required this.id,
    required this.title,
    required this.customerId,
    required this.itemType,
    this.taskStatus = TaskStatus.PENDING,
    this.detail = "",
    this.dueDate = -1,
    this.createdDate = -1,
    this.taskPriority = TaskPriority.PRIORITY_3,
  }) {
    if (this.createdDate == -1) {
      this.createdDate = DateTime.now().millisecondsSinceEpoch;
    }
    this.taskStatus = TaskStatus.PENDING;
  }

  Task.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          title: map[dbTitle],
          customerId: map[dbCustomerId],
          itemType: map[dbItemType],
          detail: map[dbDetail],
          dueDate: map[dbDueDate],
          createdDate: map[dbCreatedDate],
          taskPriority: TaskPriority.values[map[dbPriority]],
          taskStatus: TaskStatus.values[map[dbStatus]],
        );
}

enum TaskStatus {
  PENDING,
  COMPLETE,
}
enum TaskPriority{
  PRIORITY_1,
  PRIORITY_2,
  PRIORITY_3,
}