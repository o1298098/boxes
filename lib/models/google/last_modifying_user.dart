class LastModifyingUser {
  String kind;
  String displayName;
  bool me;
  String permissionId;
  String emailAddress;

  LastModifyingUser({
    this.kind,
    this.displayName,
    this.me,
    this.permissionId,
    this.emailAddress,
  });

  factory LastModifyingUser.fromJson(Map<String, dynamic> json) {
    return LastModifyingUser(
      kind: json['kind'] as String,
      displayName: json['displayName'] as String,
      me: json['me'] as bool,
      permissionId: json['permissionId'] as String,
      emailAddress: json['emailAddress'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'displayName': displayName,
      'me': me,
      'permissionId': permissionId,
      'emailAddress': emailAddress,
    };
  }
}
