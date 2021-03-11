import 'dart:ui';

import 'package:flutter/foundation.dart';

import "media_info.dart";

@immutable
class Metadata {
	final String tag;
	final String name;
	final String pathLower;
	final String pathDisplay;
	final String id;
	final DateTime clientModified;
	final DateTime serverModified;
	final String rev;
	final int size;
	final MediaInfo mediaInfo;
	final bool isDownloadable;
	final bool hasExplicitSharedMembers;
	final String contentHash;

	const Metadata({
		this.tag,
		this.name,
		this.pathLower,
		this.pathDisplay,
		this.id,
		this.clientModified,
		this.serverModified,
		this.rev,
		this.size,
		this.mediaInfo,
		this.isDownloadable,
		this.hasExplicitSharedMembers,
		this.contentHash,
	});

	@override
	String toString() {
		return 'Metadata(tag: $tag, name: $name, pathLower: $pathLower, pathDisplay: $pathDisplay, id: $id, clientModified: $clientModified, serverModified: $serverModified, rev: $rev, size: $size, mediaInfo: $mediaInfo, isDownloadable: $isDownloadable, hasExplicitSharedMembers: $hasExplicitSharedMembers, contentHash: $contentHash)';
	}

	factory Metadata.fromJson(Map<String, dynamic> json) {
		return Metadata(
			tag: json['.tag'] as String,
			name: json['name'] as String,
			pathLower: json['path_lower'] as String,
			pathDisplay: json['path_display'] as String,
			id: json['id'] as String,
			clientModified: json['client_modified'] == null ? null : DateTime.parse(json['client_modified'] as String),
			serverModified: json['server_modified'] == null ? null : DateTime.parse(json['server_modified'] as String),
			rev: json['rev'] as String,
			size: json['size'] as int,
			mediaInfo: json['media_info'] == null
					? null
					: MediaInfo.fromJson(json['media_info'] as Map<String, dynamic>),
			isDownloadable: json['is_downloadable'] as bool,
			hasExplicitSharedMembers: json['has_explicit_shared_members'] as bool,
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
			'media_info': mediaInfo?.toJson(),
			'is_downloadable': isDownloadable,
			'has_explicit_shared_members': hasExplicitSharedMembers,
			'content_hash': contentHash,
		};
	}	

Metadata copyWith({
		String tag,
		String name,
		String pathLower,
		String pathDisplay,
		String id,
		DateTime clientModified,
		DateTime serverModified,
		String rev,
		int size,
		MediaInfo mediaInfo,
		bool isDownloadable,
		bool hasExplicitSharedMembers,
		String contentHash,
	}) {
		return Metadata(
			tag: tag ?? this.tag,
			name: name ?? this.name,
			pathLower: pathLower ?? this.pathLower,
			pathDisplay: pathDisplay ?? this.pathDisplay,
			id: id ?? this.id,
			clientModified: clientModified ?? this.clientModified,
			serverModified: serverModified ?? this.serverModified,
			rev: rev ?? this.rev,
			size: size ?? this.size,
			mediaInfo: mediaInfo ?? this.mediaInfo,
			isDownloadable: isDownloadable ?? this.isDownloadable,
			hasExplicitSharedMembers: hasExplicitSharedMembers ?? this.hasExplicitSharedMembers,
			contentHash: contentHash ?? this.contentHash,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is Metadata &&
			identical(o.tag, tag) &&
			identical(o.name, name) &&
			identical(o.pathLower, pathLower) &&
			identical(o.pathDisplay, pathDisplay) &&
			identical(o.id, id) &&
			identical(o.clientModified, clientModified) &&
			identical(o.serverModified, serverModified) &&
			identical(o.rev, rev) &&
			identical(o.size, size) &&
			identical(o.mediaInfo, mediaInfo) &&
			identical(o.isDownloadable, isDownloadable) &&
			identical(o.hasExplicitSharedMembers, hasExplicitSharedMembers) &&
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
			mediaInfo,
			isDownloadable,
			hasExplicitSharedMembers,
			contentHash,
		);
	}
}
