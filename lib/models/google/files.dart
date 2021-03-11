import 'package:boxes/models/google/video_media_metadata.dart';

import "capabilities.dart";
import "export_links.dart";
import "image_media_metadata.dart";
import "last_modifying_user.dart";
import "owners.dart";
import "permissions.dart";

class Files {
  String kind;
  String id;
  String name;
  String mimeType;
  bool starred;
  bool trashed;
  bool explicitlyTrashed;
  List<dynamic> parents;
  List<dynamic> spaces;
  String version;
  String webViewLink;
  String iconLink;
  bool hasThumbnail;
  String thumbnailLink;
  String thumbnailVersion;
  bool viewedByMe;
  String viewedByMeTime;
  String createdTime;
  String modifiedTime;
  String modifiedByMeTime;
  bool modifiedByMe;
  List<Owners> owners;
  LastModifyingUser lastModifyingUser;
  bool shared;
  bool ownedByMe;
  Capabilities capabilities;
  bool viewersCanCopyContent;
  bool copyRequiresWriterPermission;
  bool writersCanShare;
  List<Permissions> permissions;
  List<dynamic> permissionIds;
  String quotaBytesUsed;
  bool isAppAuthorized;
  ExportLinks exportLinks;
  String folderColorRgb;
  String sharedWithMeTime;
  String webContentLink;
  String originalFilename;
  String fullFileExtension;
  String fileExtension;
  String md5Checksum;
  String size;
  String headRevisionId;
  ImageMediaMetadata imageMediaMetadata;
  VideoMediaMetadata videoMediaMetadata;

  Files({
    this.kind,
    this.id,
    this.name,
    this.mimeType,
    this.starred,
    this.trashed,
    this.explicitlyTrashed,
    this.parents,
    this.spaces,
    this.version,
    this.webViewLink,
    this.iconLink,
    this.hasThumbnail,
    this.thumbnailLink,
    this.thumbnailVersion,
    this.viewedByMe,
    this.viewedByMeTime,
    this.createdTime,
    this.modifiedTime,
    this.modifiedByMeTime,
    this.modifiedByMe,
    this.owners,
    this.lastModifyingUser,
    this.shared,
    this.ownedByMe,
    this.capabilities,
    this.viewersCanCopyContent,
    this.copyRequiresWriterPermission,
    this.writersCanShare,
    this.permissions,
    this.permissionIds,
    this.quotaBytesUsed,
    this.isAppAuthorized,
    this.exportLinks,
    this.folderColorRgb,
    this.sharedWithMeTime,
    this.webContentLink,
    this.originalFilename,
    this.fullFileExtension,
    this.fileExtension,
    this.md5Checksum,
    this.size,
    this.headRevisionId,
    this.imageMediaMetadata,
    this.videoMediaMetadata,
  });

  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
      kind: json['kind'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      starred: json['starred'] as bool,
      trashed: json['trashed'] as bool,
      explicitlyTrashed: json['explicitlyTrashed'] as bool,
      parents: json['parents'] as List<dynamic>,
      spaces: json['spaces'] as List<dynamic>,
      version: json['version'] as String,
      webViewLink: json['webViewLink'] as String,
      iconLink: json['iconLink'] as String,
      hasThumbnail: json['hasThumbnail'] as bool,
      thumbnailLink: json['thumbnailLink'] as String,
      thumbnailVersion: json['thumbnailVersion'] as String,
      viewedByMe: json['viewedByMe'] as bool,
      viewedByMeTime: json['viewedByMeTime'] as String,
      createdTime: json['createdTime'] as String,
      modifiedTime: json['modifiedTime'] as String,
      modifiedByMeTime: json['modifiedByMeTime'] as String,
      modifiedByMe: json['modifiedByMe'] as bool,
      owners: (json['owners'] as List)
          ?.map((e) =>
              e == null ? null : Owners.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      lastModifyingUser: json['lastModifyingUser'] == null
          ? null
          : LastModifyingUser.fromJson(
              json['lastModifyingUser'] as Map<String, dynamic>),
      shared: json['shared'] as bool,
      ownedByMe: json['ownedByMe'] as bool,
      capabilities: json['capabilities'] == null
          ? null
          : Capabilities.fromJson(json['capabilities'] as Map<String, dynamic>),
      viewersCanCopyContent: json['viewersCanCopyContent'] as bool,
      copyRequiresWriterPermission:
          json['copyRequiresWriterPermission'] as bool,
      writersCanShare: json['writersCanShare'] as bool,
      permissions: (json['permissions'] as List)
          ?.map((e) => e == null
              ? null
              : Permissions.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      permissionIds: json['permissionIds'] as List<dynamic>,
      quotaBytesUsed: json['quotaBytesUsed'] as String,
      isAppAuthorized: json['isAppAuthorized'] as bool,
      exportLinks: json['exportLinks'] == null
          ? null
          : ExportLinks.fromJson(json['exportLinks'] as Map<String, dynamic>),
      folderColorRgb: json['folderColorRgb'] as String,
      sharedWithMeTime: json['sharedWithMeTime'] as String,
      webContentLink: json['webContentLink'] as String,
      originalFilename: json['originalFilename'] as String,
      fullFileExtension: json['fullFileExtension'] as String,
      fileExtension: json['fileExtension'] as String,
      md5Checksum: json['md5Checksum'] as String,
      size: json['size'] as String,
      headRevisionId: json['headRevisionId'] as String,
      imageMediaMetadata: json['imageMediaMetadata'] == null
          ? null
          : ImageMediaMetadata.fromJson(
              json['imageMediaMetadata'] as Map<String, dynamic>,
            ),
      videoMediaMetadata: json['videoMediaMetadata'] == null
          ? null
          : VideoMediaMetadata.fromJson(
              json['videoMediaMetadata'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'id': id,
      'name': name,
      'mimeType': mimeType,
      'starred': starred,
      'trashed': trashed,
      'explicitlyTrashed': explicitlyTrashed,
      'parents': parents,
      'spaces': spaces,
      'version': version,
      'webViewLink': webViewLink,
      'iconLink': iconLink,
      'hasThumbnail': hasThumbnail,
      'thumbnailLink': thumbnailLink,
      'thumbnailVersion': thumbnailVersion,
      'viewedByMe': viewedByMe,
      'viewedByMeTime': viewedByMeTime,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
      'modifiedByMeTime': modifiedByMeTime,
      'modifiedByMe': modifiedByMe,
      'owners': owners?.map((e) => e?.toJson())?.toList(),
      'lastModifyingUser': lastModifyingUser?.toJson(),
      'shared': shared,
      'ownedByMe': ownedByMe,
      'capabilities': capabilities?.toJson(),
      'viewersCanCopyContent': viewersCanCopyContent,
      'copyRequiresWriterPermission': copyRequiresWriterPermission,
      'writersCanShare': writersCanShare,
      'permissions': permissions?.map((e) => e?.toJson())?.toList(),
      'permissionIds': permissionIds,
      'quotaBytesUsed': quotaBytesUsed,
      'isAppAuthorized': isAppAuthorized,
      'exportLinks': exportLinks?.toJson(),
      'folderColorRgb': folderColorRgb,
      'sharedWithMeTime': sharedWithMeTime,
      'webContentLink': webContentLink,
      'originalFilename': originalFilename,
      'fullFileExtension': fullFileExtension,
      'fileExtension': fileExtension,
      'md5Checksum': md5Checksum,
      'size': size,
      'headRevisionId': headRevisionId,
      'imageMediaMetadata': imageMediaMetadata?.toJson(),
      'videoMediaMetadata': videoMediaMetadata?.toJson(),
    };
  }
}
