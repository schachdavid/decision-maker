import 'dart:convert';

Decision decisionFromMap(String str) => Decision.fromMap(json.decode(str));

String decisionToMap(Decision data) => json.encode(data.toMap());

class Decision {
  String title;
  String notes;
  int id;

  Decision({
    this.title,
    this.notes,
    this.id,
  });

  factory Decision.fromMap(Map<String, dynamic> json) => new Decision(
        title: json["title"],
        notes: json["notes"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "notes": notes,
        "id": id,
      };

  @override
  String toString() {
    return "Title: '$title', notes: '$notes'";
  }
}
