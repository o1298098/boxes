import 'dart:ui';

import 'package:flutter/foundation.dart';

import "entries.dart";

@immutable
class DropboxFiles {
  final List<Entries> entries;
  final String cursor;
  final bool hasMore;

  const DropboxFiles({
    this.entries,
    this.cursor,
    this.hasMore,
  });

  @override
  String toString() {
    return 'DropboxFiles(entries: $entries, cursor: $cursor, hasMore: $hasMore)';
  }

  factory DropboxFiles.fromJson(Map<String, dynamic> json) {
    return DropboxFiles(
      entries: (json['entries'] as List)
          ?.map((e) =>
              e == null ? null : Entries.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      cursor: json['cursor'] as String,
      hasMore: json['has_more'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries?.map((e) => e?.toJson())?.toList(),
      'cursor': cursor,
      'has_more': hasMore,
    };
  }

  DropboxFiles copyWith({
    List<Entries> entries,
    String cursor,
    bool hasMore,
  }) {
    return DropboxFiles(
      entries: entries ?? this.entries,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is DropboxFiles &&
      identical(o.entries, entries) &&
      identical(o.cursor, cursor) &&
      identical(o.hasMore, hasMore);

  @override
  int get hashCode => hashValues(entries, cursor, hasMore);
}
