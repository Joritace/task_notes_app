class TaskItem {
  int? id;
  String title;
  String description;
  String priority;
  bool isCompleted;

  TaskItem({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'isCompleted': isCompleted ? 1 : 0,
      };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        priority: json['priority'],
        isCompleted: json['isCompleted'] == 1,
      );
}
