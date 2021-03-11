import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'low_metadata.dart';

@immutable
class MediaInfo {
  final String tag;
  final LowMetadata metadata;

  const MediaInfo({this.tag, this.metadata});

  @override
  String toString() {
    return 'MediaInfo(tag: $tag, metadata: $metadata)';
  }

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      tag: json['.tag'] as String,
      metadata: json['metadata'] == null
          ? null
          : LowMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '.tag': tag,
      'metadata': metadata?.toJson(),
    };
  }

  MediaInfo copyWith({
    String tag,
    LowMetadata metadata,
  }) {
    return MediaInfo(
      tag: tag ?? this.tag,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is MediaInfo &&
      identical(o.tag, tag) &&
      identical(o.metadata, metadata);

  @override
  int get hashCode => hashValues(tag, metadata);
}
