class Todo {
  String content;
  bool done;
  DateTime creationDate; // Oluşturulma tarihi
  DateTime lastUpdated; 

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
      "creationDate": creationDate.toString(), // Oluşturulma tarihini json nüştür
      "lastUpdated": lastUpdated.toString(), 
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      content: map["content"],
      done: map["done"],
      creationDate: DateTime.parse(map["creationDate"]), // Jsondan oluşturulma tarihini dönüştür
      lastUpdated: DateTime.parse(map["lastUpdated"]), 
    );
  }
}