// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Decision _$DecisionFromJson(Map<String, dynamic> json) {
  return Decision(
      proArgs: (json['proArgs'] as List)?.map((e) => e as String)?.toList(),
      conArgs: (json['conArgs'] as List)?.map((e) => e as String)?.toList(),
      notes: json['notes'] as String,
      title: json['title'] as String,
      key: json['key'] as String);
}

Map<String, dynamic> _$DecisionToJson(Decision instance) => <String, dynamic>{
      'proArgs': instance.proArgs,
      'conArgs': instance.conArgs,
      'title': instance.title,
      'notes': instance.notes,
      'key': instance.key
    };
