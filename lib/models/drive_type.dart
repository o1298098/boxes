import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class DriveType {
  final int id;
  final String name;
  final String code;

  const DriveType({
    this.id,
    this.name,
    this.code,
  });

  @override
  String toString() {
    return '{"id": $id, "name": "${name ?? ''}", "code": "${code ?? ''}"}';
  }

  factory DriveType.fromJson(Map<String, dynamic> json) {
    return DriveType(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  DriveType copyWith({
    int id,
    String name,
    String code,
  }) {
    return DriveType(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is DriveType &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.code, code);

  @override
  int get hashCode => hashValues(id, name, code);
}
