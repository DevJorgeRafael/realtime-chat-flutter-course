import 'dart:convert';
import 'package:realtime_chat/shared/models/user.dart';

List<Room> roomsResponseFromJson(dynamic data) =>
    List<Room>.from(data.map((x) => Room.fromJson(x)));

String roomsResponseToJson(List<Room> data) =>
    json.encode(List<Map<String, dynamic>>.from(data.map((x) => x.toJson())));

class Room {
  final String id;
  final String name;
  final List<User> members;

  Room({
    required this.id, 
    required this.name, 
    required this.members
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        name: json["name"],
        members: List<User>.from(json["members"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}    