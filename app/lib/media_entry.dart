import 'package:json_annotation/json_annotation.dart';

part 'media_entry.g.dart';

@JsonSerializable()
class MediaEntry {
  final String type;
  final String name;
  final String description;
  final String file;

  MediaEntry(this.type, this.name, this.description, this.file);

  factory MediaEntry.fromJson(Map<String, dynamic> json) => _$MediaEntryFromJson(json);
}
