class Argument {
  Argument({this.text, this.id, this.decisionId});
  String text;
  int id;
  int decisionId;

  @override
  String toString() {
    return "ProArg Text: '$text'";
  }
}
