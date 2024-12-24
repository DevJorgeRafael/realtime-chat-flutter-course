// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat/models/user.dart';

List<User> usersResponseFromjson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersResponseTojson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersResponse {
  final String name;
  final String email;
  final bool online;
  final String id;

  UsersResponse({
    required this.name,
    required this.email,
    required this.online,
    required this.id,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        name: json["name"],
        email: json["email"],
        online: json["online"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "online": online,
        "id": id,
      };
}
