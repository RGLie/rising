class User {
  int id;
  String username;
  String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  // Json 받아서 모델 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,

    };
  }

}
