import 'dart:ui';

import 'package:boxes/models/models.dart';

import 'drive_type.dart';

class UserDrive {
  final int id;
  final String name;
  String accessToken;
  final String scope;
  final String refreshToken;
  final String tokenType;
  final dynamic driveId;
  final String expiresIn;
  final String updateTime;
  final DriveType driveType;
  DriveUsage driveUsage;

  UserDrive({
    this.id,
    this.name,
    this.accessToken,
    this.scope,
    this.refreshToken,
    this.tokenType,
    this.driveId,
    this.expiresIn,
    this.updateTime,
    this.driveType,
    this.driveUsage,
  });

  @override
  String toString() {
    return '{"id": $id, "name": "${name ?? ''}", "accessToken": "${accessToken ?? ''}", "scope": "${scope ?? ''}", "refreshToken": "${refreshToken ?? ''}", "tokenType": "${tokenType ?? ''}", "driveId": "${driveId ?? ''}", "expiresIn": "${expiresIn ?? ''}", "updateTime": "${updateTime ?? ''}", "driveTypeNavigation":$driveType,"driveUsage":$driveUsage}';
  }

  factory UserDrive.fromJson(Map<String, dynamic> json) {
    return UserDrive(
      id: json['id'] as int,
      name: json['name'] as String,
      accessToken: json['accessToken'] as String,
      scope: json['scope'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      driveId: json['driveId'] as dynamic,
      expiresIn: json['expiresIn'] as String,
      updateTime: json['updateTime'] as String,
      driveType: json['driveTypeNavigation'] == null
          ? null
          : DriveType.fromJson(json['driveTypeNavigation']),
      driveUsage: json['driveUsage'] == null
          ? null
          : DriveUsage.fromJson(json['driveUsage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accessToken': accessToken,
      'scope': scope,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'driveId': driveId,
      'expiresIn': expiresIn,
      'updateTime': updateTime,
      'driveTypeNavigation': driveType?.toString(),
      'driveUsage': driveUsage?.toString(),
    };
  }

  UserDrive copyWith({
    int id,
    String name,
    String accessToken,
    String scope,
    String refreshToken,
    String tokenType,
    dynamic driveId,
    String expiresIn,
    String updateTime,
    DriveType driveType,
  }) {
    return UserDrive(
      id: id ?? this.id,
      name: name ?? this.name,
      accessToken: accessToken ?? this.accessToken,
      scope: scope ?? this.scope,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      driveId: driveId ?? this.driveId,
      expiresIn: expiresIn ?? this.expiresIn,
      updateTime: updateTime ?? this.updateTime,
      driveType: driveType ?? this.driveType,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is UserDrive &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.accessToken, accessToken) &&
      identical(o.scope, scope) &&
      identical(o.refreshToken, refreshToken) &&
      identical(o.tokenType, tokenType) &&
      identical(o.driveId, driveId) &&
      identical(o.expiresIn, expiresIn) &&
      identical(o.updateTime, updateTime) &&
      identical(o.driveType, driveType);

  @override
  int get hashCode {
    return hashValues(
      id,
      name,
      accessToken,
      scope,
      refreshToken,
      tokenType,
      driveId,
      expiresIn,
      updateTime,
      driveType,
    );
  }
}
