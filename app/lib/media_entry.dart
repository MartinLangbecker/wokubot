import 'package:json_annotation/json_annotation.dart';

part 'media_entry.g.dart';

enum MediaType { IMAGE, AUDIO, VIDEO }

@JsonSerializable()
class MediaEntry {
  int? id;
  String? name;
  String? description;
  String? file;
  MediaType? type;

  MediaEntry({this.id, this.name, this.description, this.file, this.type});

  @override
  String toString() {
    return 'MediaEntry: ${toJson()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaEntry &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          file == other.file &&
          type == other.type;

  @override
  int get hashCode =>
      identityHashCode(id) ^
      identityHashCode(name) ^
      identityHashCode(description) ^
      identityHashCode(file) ^
      identityHashCode(type);

  factory MediaEntry.fromJson(Map<String, dynamic> json) => _$MediaEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MediaEntryToJson(this);

  factory MediaEntry.fromMap(Map<String, dynamic> data) => MediaEntry(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        file: data['file'],
        type: MediaType.values.firstWhere((element) => element.toString() == data['type']),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'file': file,
      'type': type.toString(),
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'description': description,
      'file': file,
      'type': type.toString(),
    };
  }

  MediaEntry copyWith({
    int? id,
    String? name,
    String? description,
    String? file,
    MediaType? type,
  }) =>
      MediaEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        file: file ?? this.file,
        type: type ?? this.type,
      );
}
