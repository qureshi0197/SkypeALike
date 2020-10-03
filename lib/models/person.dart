class Person {
  int id;
  int userId;
  String title;
  String body;

  Person({this.id, this.userId, this.title, this.body});

  factory Person.fromMap(Map<String, dynamic> json) => new Person(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "title": title,
        "body": body
      };
}