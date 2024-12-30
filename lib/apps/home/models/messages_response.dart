import 'dart:convert';

MessagesResponse mensajesResponseFromJson(String str) =>
    MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) =>
    json.encode(data.toJson());

class MessagesResponse {
  final bool ok;
  final List<Message> messages;

  MessagesResponse({
    required this.ok,
    required this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  final String from;
  final String to;
  final String type;
  final String? fileUrl;
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.from,
    required this.to,
    required this.type,
    this.fileUrl,
    this.message,
    
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        type: json["type"],
        fileUrl: json["fileUrl"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "type": type,
        "fileUrl": fileUrl,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
