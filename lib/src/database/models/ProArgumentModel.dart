import 'dart:convert';

ProArgument ProArgumentFromMap(String str) => ProArgument.fromMap(json.decode(str));

String ProArgumentToMap(ProArgument data) => json.encode(data.toMap());

class ProArgument {
  String text;
  int id;
  int decisionId;


  ProArgument({
    this.text,
    this.decisionId,
    this.id,
  });

  factory ProArgument.fromMap(Map<String, dynamic> json) => new ProArgument(
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
    return "ProArg Text: '$text', Id: '$id'";
  }
}
