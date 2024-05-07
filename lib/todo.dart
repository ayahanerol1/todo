class Todo {
  String content;

  // tamamlandı
  bool done;

  Todo(this.content, this.done);

  Map<String, dynamic> toJson() {
    return {"content": content, "done": done};
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(map["content"], map["done"]);
  }
}
