class TodoWork {
  String title;
  bool isDone;

  TodoWork(this.title, this.isDone);

  Map<String, dynamic> toJson() => {
    'title': title,
    'isDone': isDone,
  };

  factory TodoWork.fromJson(Map<String, dynamic> json) => TodoWork(
    json['title'] as String,
    json['isDone'] as bool,
  );
}