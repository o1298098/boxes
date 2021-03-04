import "files.dart";

class GoogleFiles {
  String kind;
  bool incompleteSearch;
  List<Files> files;

  GoogleFiles({
    this.kind,
    this.incompleteSearch,
    this.files,
  });

  factory GoogleFiles.fromJson(Map<String, dynamic> json) {
    return GoogleFiles(
      kind: json['kind'] as String,
      incompleteSearch: json['incompleteSearch'] as bool,
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
      'files': files?.map((e) => e?.toJson())?.toList(),
    };
  }
}
