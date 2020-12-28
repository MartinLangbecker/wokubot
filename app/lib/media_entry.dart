class MediaEntry {
  final String type;
  final String name;
  final String description;
  final String file;

  MediaEntry(this.type, this.name, this.description, this.file);

  MediaEntry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        name = json['name'],
        description = json['description'],
        file = json['file'];
}
