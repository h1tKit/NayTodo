class TodoWork {
  final String id;
  String title;
  bool isDone;

  TodoWork({
    String? id,
    required this.title,
    this.isDone = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
  };

  factory TodoWork.fromJson(Map<String, dynamic> json) => TodoWork(
    id: json['id'] as String?,
    title: json['title'] as String,
    isDone: json['isDone'] as bool,
  );
}