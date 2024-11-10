class Note {
  final int? id;
  final String title;
  final String body;
  final String date;
  final String color;

  // Constructor for note class
  Note({this.id, required this.title, required this.body, required this.date, required this.color});

  Note.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        body = res["body"],
        date = res["date"],
        color = res["color"];

  // Return a note object
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date,
      'color': color,
    };
  }
}
