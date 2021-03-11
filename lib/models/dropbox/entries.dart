import 'package:boxes/models/dropbox/metadata.dart';

class Entries {
  String tag;
  Metadata metadata;
  String thumbnail;

  Entries({
    this.tag,
    this.metadata,
    this.thumbnail,
  });

  factory Entries.fromJson(Map<String, dynamic> json) {
    return Entries(
      tag: json['.tag'] as String,
      metadata: json['metadata'] == null
          ? null
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      thumbnail: json['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '.tag': tag,
      'metadata': metadata?.toJson(),
      'thumbnail': thumbnail,
    };
  }

  Entries copyWith({
    String tag,
    Metadata metadata,
    String thumbnail,
  }) {
    return Entries(
      tag: tag ?? this.tag,
      metadata: metadata ?? this.metadata,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
