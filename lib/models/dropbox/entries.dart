import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class Entries {
  final String tag;
  final String name;
  final String pathLower;
  final String pathDisplay;
  final String id;
  final DateTime clientModified;
  final DateTime serverModified;
  final String rev;
  final int size;
  final bool isDownloadable;
  final String contentHash;

  const Entries({
    this.tag,
    this.name,
    this.pathLower,
    this.pathDisplay,
    this.id,
    this.clientModified,
    this.serverModified,
    this.rev,
    this.size,
    this.isDownloadable,
    this.contentHash,
  });

  @override
  String toString() {
    return 'Entries(tag: $tag, name: $name, pathLower: $pathLower, pathDisplay: $pathDisplay, id: $id, clientModified: $clientModified, serverModified: $serverModified, rev: $rev, size: $size, isDownloadable: $isDownloadable, contentHash: $contentHash)';
  }

  factory Entries.fromJson(Map<String, dynamic> json) {
    return Entries(
      tag: json['.tag'] as String,
      name: json['name'] as String,
      pathLower: json['path_lower'] as String,
      pathDisplay: json['path_display'] as String,
      id: json['id'] as String,
      clientModified: json['client_modified'] == null
          ? null
          : DateTime.parse(json['client_modified'] as String),
      serverModified: json['server_modified'] == null
          ? null
          : DateTime.parse(json['server_modified'] as String),
      rev: json['rev'] as String,
      size: json['size'] as int,
      isDownloadable: json['is_downloadable'] as bool,
      contentHash: json['content_hash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '.tag': tag,
      'name': name,
      'path_lower': pathLower,
      'path_display': pathDisplay,
      'id': id,
      'client_modified': clientModified?.toIso8601String(),
      'server_modified': serverModified?.toIso8601String(),
      'rev': rev,
      'size': size,
      'is_downloadable': isDownloadable,
      'content_hash': contentHash,
    };
  }

  Entries copyWith({
    String tag,
    String name,
    String pathLower,
    String pathDisplay,
    String id,
    DateTime clientModified,
    DateTime serverModified,
    String rev,
    int size,
    bool isDownloadable,
    String contentHash,
  }) {
    return Entries(
      tag: tag ?? this.tag,
      name: name ?? this.name,
      pathLower: pathLower ?? this.pathLower,
      pathDisplay: pathDisplay ?? this.pathDisplay,
      id: id ?? this.id,
      clientModified: clientModified ?? this.clientModified,
      serverModified: serverModified ?? this.serverModified,
      rev: rev ?? this.rev,
      size: size ?? this.size,
      isDownloadable: isDownloadable ?? this.isDownloadable,
      contentHash: contentHash ?? this.contentHash,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is Entries &&
      identical(o.tag, tag) &&
      identical(o.name, name) &&
      identical(o.pathLower, pathLower) &&
      identical(o.pathDisplay, pathDisplay) &&
      identical(o.id, id) &&
      identical(o.clientModified, clientModified) &&
      identical(o.serverModified, serverModified) &&
      identical(o.rev, rev) &&
      identical(o.size, size) &&
      identical(o.isDownloadable, isDownloadable) &&
      identical(o.contentHash, contentHash);

  @override
  int get hashCode {
    return hashValues(
      tag,
      name,
      pathLower,
      pathDisplay,
      id,
      clientModified,
      serverModified,
      rev,
      size,
      isDownloadable,
      contentHash,
    );
  }
}
