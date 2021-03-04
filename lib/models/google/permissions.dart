class Permissions {
  String kind;
  String id;
  String type;
  String emailAddress;
  String role;
  String displayName;
  bool deleted;

  Permissions({
    this.kind,
    this.id,
    this.type,
    this.emailAddress,
    this.role,
    this.displayName,
    this.deleted,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      kind: json['kind'] as String,
      id: json['id'] as String,
      type: json['type'] as String,
      emailAddress: json['emailAddress'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String,
      deleted: json['deleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'id': id,
      'type': type,
      'emailAddress': emailAddress,
      'role': role,
      'displayName': displayName,
      'deleted': deleted,
    };
  }
}
