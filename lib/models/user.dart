import 'dart:ui';

import 'package:boxes/models/user_drive.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String createTime;
  final String photoUrl;
  final List<UserDrive> userDrives;

  const User({
    this.uid,
    this.name,
    this.phone,
    this.email,
    this.createTime,
    this.photoUrl,
    this.userDrives,
  });

  @override
  String toString() {
    return '{"uid":"$uid", "name":"${name ?? ''}", "phone":"${phone ?? ''}", "email":"${email ?? ''}", "createTime": "${createTime ?? DateTime.now().toIso8601String()}", "photoUrl": "${photoUrl ?? ''}", "tUserDrives": ${userDrives ?? []} }';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      createTime: json['createTime'] as String,
      photoUrl: json['photoUrl'] as String,
      userDrives: (json['tUserDrives'] as List)
              ?.map((e) => e == null
                  ? null
                  : UserDrive.fromJson(e as Map<String, dynamic>))
              ?.toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'createTime': createTime,
      'photoUrl': photoUrl,
      'tUserDrives': userDrives?.map((e) => e?.toJson())?.toList() ?? [],
    };
  }

  User copyWith({
    String uid,
    String name,
    String phone,
    String email,
    String createTime,
    String photoUrl,
    List<UserDrive> userDrives,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createTime: createTime ?? this.createTime,
      photoUrl: photoUrl ?? this.photoUrl,
      userDrives: userDrives ?? this.userDrives,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is User &&
      identical(o.uid, uid) &&
      identical(o.name, name) &&
      identical(o.phone, phone) &&
      identical(o.email, email) &&
      identical(o.createTime, createTime) &&
      identical(o.photoUrl, photoUrl) &&
      identical(o.userDrives, userDrives);

  @override
  int get hashCode {
    return hashValues(
      uid,
      name,
      phone,
      email,
      createTime,
      photoUrl,
      userDrives,
    );
  }
}
