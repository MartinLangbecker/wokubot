import 'package:json_annotation/json_annotation.dart';

part 'media_entry.g.dart';

@JsonSerializable()
class MediaEntry {
  int id;
  String type;
  String name;
  String description;
  String file;

  MediaEntry([this.id, this.type, this.name, this.description, this.file]);

  factory MediaEntry.fromJson(Map<String, dynamic> json) => _$MediaEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MediaEntryToJson(this);

  factory MediaEntry.fromMap(Map<String, dynamic> data) => new MediaEntry(
        data['id'],
        data['type'],
        data['name'],
        data['description'],
        data['file'],
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
