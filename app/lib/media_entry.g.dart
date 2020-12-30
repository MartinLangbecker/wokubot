// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaEntry _$MediaEntryFromJson(Map<String, dynamic> json) {
  return MediaEntry(
    json['id'] as int,
    json['name'] as String,
    json['description'] as String,
    json['file'] as String,
    _$enumDecodeNullable(_$MediaTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$MediaEntryToJson(MediaEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'file': instance.file,
      'type': _$MediaTypeEnumMap[instance.type],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MediaTypeEnumMap = {
  MediaType.IMAGE: 'IMAGE',
  MediaType.AUDIO: 'AUDIO',
  MediaType.VIDEO: 'VIDEO',
};
