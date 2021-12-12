// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaEntry _$MediaEntryFromJson(Map<String, dynamic> json) => MediaEntry(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      file: json['file'] as String?,
      type: $enumDecodeNullable(_$MediaTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MediaEntryToJson(MediaEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'file': instance.file,
      'type': _$MediaTypeEnumMap[instance.type],
    };

const _$MediaTypeEnumMap = {
  MediaType.IMAGE: 'IMAGE',
  MediaType.AUDIO: 'AUDIO',
  MediaType.VIDEO: 'VIDEO',
};
