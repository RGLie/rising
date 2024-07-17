class Memo {
  int id;
  int author_id;
  String content;
  String date;
  int is_private;

  Memo({
    required this.id,
    required this.author_id,
    required this.content,
    required this.date,
    required this.is_private,
  });

  // Json 받아서 모델 생성
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      author_id: json['author_id'],
      content: json['content'],
      date: json['date'],
      is_private: json['is_private'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': author_id,
      'content': content,
      'date': date,
      'is_private': is_private

    };
  }

}
