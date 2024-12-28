class User {
  final String id;
  final String name;
  final String email;
  final bool online;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.online,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "online": online,
      };
}
