import 'package:decision_maker/src/plainObjects/question.dart';



class QuestionDao {
  Question fromMap(Map<String, dynamic> query) {
    Question question = Question();
    question.id = query["id"];
    question.text = query["text"];
    return question;
  }

  Map<String, dynamic> toMap(Question object) {
    return <String, dynamic>{
      "text": object.text,
    };
  }
}