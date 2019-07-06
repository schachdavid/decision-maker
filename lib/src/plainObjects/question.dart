

class Question {
  Question({this.text, this.id});
  String text;
  int id;

  @override
  String toString() {
    return "Question: '$text'";
  }
}
