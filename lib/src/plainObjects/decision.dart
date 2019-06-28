import 'package:json_annotation/json_annotation.dart';
part 'decision.g.dart';

@JsonSerializable()
class Decision {
  Decision({this.proArgs, this.conArgs, this.notes, this.title, this.key});
  List<String> proArgs;
  List<String> conArgs;
  String title;
  String notes;
  String key;

  factory Decision.fromJson(Map<String, dynamic> json) => _$DecisionFromJson(json);
  Map<String, dynamic> toJson() => _$DecisionToJson(this);
 
}
