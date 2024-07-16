class Memo {
  int id;
  int author_id;
  String content;
  DateTime created_at;
  String date;
  bool is_private;

  Memo({
    required this.id,
    required this.author_id,
    required this.content,
    required this.created_at,
    required this.date,
    required this.is_private,
  });

  // Json 받아서 모델 생성
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      author_id: json['author_id'],
      content: json['content'],
      created_at: DateTime.parse(json["create_date"]),
      date: json['date'],
      is_private: json['is_private'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': author_id,
      'content': content,
      'created_at': created_at,
      'date': date,
      'is_private': is_private

    };
  }

}
