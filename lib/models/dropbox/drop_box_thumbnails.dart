import "entries.dart";

class DropBoxThumbnails {
  List<Entries> entries;

  DropBoxThumbnails({this.entries});

  factory DropBoxThumbnails.fromJson(Map<String, dynamic> json) {
    return DropBoxThumbnails(
      entries: (json['entries'] as List)
          ?.map((e) =>
              e == null ? null : Entries.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries?.map((e) => e?.toJson())?.toList(),
    };
  }

  DropBoxThumbnails copyWith({
    List<Entries> entries,
  }) {
    return DropBoxThumbnails(
      entries: entries ?? this.entries,
    );
  }
}
