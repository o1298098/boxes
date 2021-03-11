import "files.dart";

class GoogleFiles {
  String kind;
  bool incompleteSearch;
  String nextPageToken;
  List<Files> files;

  GoogleFiles({
    this.kind,
    this.incompleteSearch,
    this.nextPageToken,
    this.files,
  });

  factory GoogleFiles.fromJson(Map<String, dynamic> json) {
    return GoogleFiles(
      kind: json['kind'] as String,
      incompleteSearch: json['incompleteSearch'] as bool,
      nextPageToken: json['nextPageToken'] as String,
      files: (json['files'] as List)
          ?.map((e) =>
              e == null ? null : Files.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'incompleteSearch': incompleteSearch,
      'nextPageToken': nextPageToken,
      'files': files?.map((e) => e?.toJson())?.toList(),
    };
  }
}
