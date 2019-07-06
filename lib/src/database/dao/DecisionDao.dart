import 'package:decision_maker/src/plainObjects/decision.dart';


class DecisionDao {
  Decision fromMap(Map<String, dynamic> query) {
    Decision decision = Decision();
    decision.id = query["id"];
    decision.title = query["title"];
    decision.notes = query["notes"];
    decision.questionId = query["question_id"];
    return decision;
  }

  Map<String, dynamic> toMap(Decision object) {
    return <String, dynamic>{
      "title": object.title,
      "notes": object.notes,
      "question_id": object.questionId
    };
  }
}
