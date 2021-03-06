import 'package:json_annotation/json_annotation.dart';

part 'media_entry.g.dart';

enum MediaType { IMAGE, AUDIO, VIDEO }

@JsonSerializable()
class MediaEntry {
  int id;
  String name;
  String description;
  String file;
  MediaType type;

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

  factory MediaEntry.fromMap(Map<String, dynamic> data) => new MediaEntry(
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
    Nullable<int> id,
    Nullable<String> name,
    Nullable<String> description,
    Nullable<String> file,
    Nullable<MediaType> type,
  }) =>
      MediaEntry(
        id: id == null
            ? this.id
            : id.value == null
                ? null
                : id.value,
        name: name == null
            ? this.name
            : name.value == null
                ? null
                : name.value,
        description: description == null
            ? this.description
            : description.value == null
                ? null
                : description.value,
        file: file == null
            ? this.file
            : file.value == null
                ? null
                : file.value,
        type: type == null
            ? this.type
            : type.value == null
                ? null
                : type.value,
      );
}

class Nullable<T> {
  T _value;
  Nullable(this._value);
  T get value {
    return _value;
  }
}
