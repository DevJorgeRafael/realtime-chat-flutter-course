import 'dart:convert';

import 'package:realtime_chat/shared/models/user.dart';

List<User> usersResponseFromjson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersResponseTojson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersResponse {
  final List<User> users;

  UsersResponse({
    required this.users,
  });

  factory UsersResponse.fromList(List<dynamic> jsonList) {
    final users = List<User>.from(jsonList.map((x) => User.fromJson(x)));
    return UsersResponse(users: users);
  }

  factory UsersResponse.fromJson(String str) {
    final jsonList = json.decode(str) as List<dynamic>;
    final users = List<User>.from(jsonList.map((x) => User.fromJson(x)));
    return UsersResponse(users: users);
  }

  String toJson() => json.encode(users.map((x) => x.toJson()).toList());
}
