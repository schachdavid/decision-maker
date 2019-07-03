import 'package:json_annotation/json_annotation.dart';
part 'decision.g.dart';

class Decision {
  Decision({this.proArgs, this.conArgs, this.notes, this.title, this.key});
  List<String> proArgs;
  List<String> conArgs;
  String title;
  String notes;
  String key;

  


}
