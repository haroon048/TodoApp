class TodoModel {
  final int? id;
  final String title;
  final String? description;
  final bool completed;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json["id"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      completed: json["completed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "completed": completed,
    };
  }
}
