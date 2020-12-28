import 'package:json_annotation/json_annotation.dart';

part 'media_entry.g.dart';

@JsonSerializable()
class MediaEntry {
  final int id;
  final String type;
  final String name;
  final String description;
  final String file;

  MediaEntry(this.type, this.name, this.description, this.file, this.id);

  factory MediaEntry.fromJson(Map<String, dynamic> json) => _$MediaEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MediaEntryToJson(this);

  factory MediaEntry.fromMap(Map<String, dynamic> data) => new MediaEntry(
        data['type'],
        data['name'],
        data['description'],
        data['file'],
        data['id'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'file': file,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'type': type,
      'name': name,
      'description': description,
      'file': file,
    };
  }
}
