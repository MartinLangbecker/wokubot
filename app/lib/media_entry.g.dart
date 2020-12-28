// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaEntry _$MediaEntryFromJson(Map<String, dynamic> json) {
  return MediaEntry(
    json['type'] as String,
    json['name'] as String,
    json['description'] as String,
    json['file'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$MediaEntryToJson(MediaEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'file': instance.file,
    };
