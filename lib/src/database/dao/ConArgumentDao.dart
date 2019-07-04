import '../../plainObjects/conArgument.dart';

class ConArgumentDao {
  ConArgument fromMap(Map<String, dynamic> query) {
    ConArgument arg = ConArgument();
    arg.id = query["id"];
    arg.text = query["text"];
    arg.decisionId = query["decision_id"];
    return arg;
  }

  Map<String, dynamic> toMap(ConArgument object) {
    return <String, dynamic>{
      "text": object.text,
      "decision_id": object.decisionId
    };
  }
}
