class TaskItem {
  int? id; // optional for new tasks before inserting in DB
  String title;
  String priority;
  String description;
  bool isCompleted;

  TaskItem({
    this.id,
    required this.title,
    required this.priority,
    required this.description,
    this.isCompleted = false,
  });

  // Convert TaskItem object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // store as int for SQFLite
    };
  }

  // Create TaskItem object from JSON map
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      description: json['description'],
      isCompleted: json['isCompleted'] == 1 ? true : false,
    );
  }
}
