import 'package:decision_maker/src/plainObjects/conArgument.dart';
import 'package:decision_maker/src/plainObjects/proArgument.dart';

class Decision {
  Decision({this.proArgs, this.conArgs, this.notes, this.title, this.id, this.questionId});
  List<ProArgument> proArgs;
  List<ConArgument> conArgs;
  String title;
  String notes;
  int id;
  int questionId;

  @override
  String toString() {
    return "Title: '$title', notes: '$notes'";
  }
}
