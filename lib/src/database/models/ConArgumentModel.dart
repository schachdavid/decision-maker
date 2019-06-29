import 'dart:convert';

ConArgument ConArgumentFromMap(String str) => ConArgument.fromMap(json.decode(str));

String ConArgumentToMap(ConArgument data) => json.encode(data.toMap());

class ConArgument {
  String text;
  int id;
  int decisionId;


  ConArgument({
    this.text,
    this.decisionId,
    this.id,
  });

  factory ConArgument.fromMap(Map<String, dynamic> json) => new ConArgument(
        text: json["text"],
        decisionId: json["decision_id"],
        id: json["id"],

      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "decision_id": decisionId,
        "id": id,
      };

  @override
  String toString() {
    return "ConArg Text: '$text', Id: '$id'";
  }
}
