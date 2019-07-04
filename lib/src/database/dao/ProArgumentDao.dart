import '../../plainObjects/proArgument.dart';

class ProArgumentDao {
  ProArgument fromMap(Map<String, dynamic> query) {
    ProArgument arg = ProArgument();
    arg.id = query["id"];
    arg.text = query["text"];
    arg.decisionId = query["decision_id"];
    return arg;
  }

  Map<String, dynamic> toMap(ProArgument object) {
    return <String, dynamic>{
      "text": object.text,
      "decision_id": object.decisionId
    };
  }
}
