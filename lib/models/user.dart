class User {
  final String id;
  final String name;
  final String email;
  final bool online;
  final int v;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.online,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        online: json["online"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "online": online,
        "__v": v,
      };
}
