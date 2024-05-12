class Todo {
  String content;
  bool done;
  DateTime creationDate; // Oluşturulma tarihi
  DateTime lastUpdated; // Son güncelleme tarihi

  Todo({
    required this.content,
    required this.done,
    required this.creationDate,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "done": done,
      "creationDate": creationDate.toIso8601String(), // Oluşturulma tarihini JSON'a dönüştür
      "lastUpdated": lastUpdated.toIso8601String(), // Son güncelleme tarihini JSON'a dönüştür
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      content: map["content"],
      done: map["done"],
      creationDate: DateTime.parse(map["creationDate"]), // JSON'dan oluşturulma tarihini dönüştür
      lastUpdated: DateTime.parse(map["lastUpdated"]), // JSON'dan son güncelleme tarihini dönüştür
    );
  }
  
}
