class User {
  int id;
  String username;
  String email;
  DateTime created_at;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.created_at,
  });

  // Json 받아서 모델 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        created_at: DateTime.parse(json["create_date"]),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': created_at

    };
  }

}
