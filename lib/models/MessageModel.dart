import 'dart:convert';

Message clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Message.fromMap(jsonData);
}

String clientToJson(Message data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

// Создаем модель сообщения
class Message{
  int id;
  String content;

  Message({
    this.id,
    this.content,
  });

  factory Message.fromMap(Map<String, dynamic> json) => new Message(
    id: json["id"],
    content: json["content"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "content": content,
  };
}