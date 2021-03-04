class Capabilities {
  bool canAddChildren;
  bool canAddMyDriveParent;
  bool canChangeCopyRequiresWriterPermission;
  bool canChangeViewersCanCopyContent;
  bool canComment;
  bool canCopy;
  bool canDelete;
  bool canDownload;
  bool canEdit;
  bool canListChildren;
  bool canModifyContent;
  bool canMoveChildrenWithinDrive;
  bool canMoveItemIntoTeamDrive;
  bool canMoveItemOutOfDrive;
  bool canMoveItemWithinDrive;
  bool canReadRevisions;
  bool canRemoveChildren;
  bool canRemoveMyDriveParent;
  bool canRename;
  bool canShare;
  bool canTrash;
  bool canUntrash;

  Capabilities({
    this.canAddChildren,
    this.canAddMyDriveParent,
    this.canChangeCopyRequiresWriterPermission,
    this.canChangeViewersCanCopyContent,
    this.canComment,
    this.canCopy,
    this.canDelete,
    this.canDownload,
    this.canEdit,
    this.canListChildren,
    this.canModifyContent,
    this.canMoveChildrenWithinDrive,
    this.canMoveItemIntoTeamDrive,
    this.canMoveItemOutOfDrive,
    this.canMoveItemWithinDrive,
    this.canReadRevisions,
    this.canRemoveChildren,
    this.canRemoveMyDriveParent,
    this.canRename,
    this.canShare,
    this.canTrash,
    this.canUntrash,
  });

  factory Capabilities.fromJson(Map<String, dynamic> json) {
    return Capabilities(
      canAddChildren: json['canAddChildren'] as bool,
      canAddMyDriveParent: json['canAddMyDriveParent'] as bool,
      canChangeCopyRequiresWriterPermission:
          json['canChangeCopyRequiresWriterPermission'] as bool,
      canChangeViewersCanCopyContent:
          json['canChangeViewersCanCopyContent'] as bool,
      canComment: json['canComment'] as bool,
      canCopy: json['canCopy'] as bool,
      canDelete: json['canDelete'] as bool,
      canDownload: json['canDownload'] as bool,
      canEdit: json['canEdit'] as bool,
      canListChildren: json['canListChildren'] as bool,
      canModifyContent: json['canModifyContent'] as bool,
      canMoveChildrenWithinDrive: json['canMoveChildrenWithinDrive'] as bool,
      canMoveItemIntoTeamDrive: json['canMoveItemIntoTeamDrive'] as bool,
      canMoveItemOutOfDrive: json['canMoveItemOutOfDrive'] as bool,
      canMoveItemWithinDrive: json['canMoveItemWithinDrive'] as bool,
      canReadRevisions: json['canReadRevisions'] as bool,
      canRemoveChildren: json['canRemoveChildren'] as bool,
      canRemoveMyDriveParent: json['canRemoveMyDriveParent'] as bool,
      canRename: json['canRename'] as bool,
      canShare: json['canShare'] as bool,
      canTrash: json['canTrash'] as bool,
      canUntrash: json['canUntrash'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canAddChildren': canAddChildren,
      'canAddMyDriveParent': canAddMyDriveParent,
      'canChangeCopyRequiresWriterPermission':
          canChangeCopyRequiresWriterPermission,
      'canChangeViewersCanCopyContent': canChangeViewersCanCopyContent,
      'canComment': canComment,
      'canCopy': canCopy,
      'canDelete': canDelete,
      'canDownload': canDownload,
      'canEdit': canEdit,
      'canListChildren': canListChildren,
      'canModifyContent': canModifyContent,
      'canMoveChildrenWithinDrive': canMoveChildrenWithinDrive,
      'canMoveItemIntoTeamDrive': canMoveItemIntoTeamDrive,
      'canMoveItemOutOfDrive': canMoveItemOutOfDrive,
      'canMoveItemWithinDrive': canMoveItemWithinDrive,
      'canReadRevisions': canReadRevisions,
      'canRemoveChildren': canRemoveChildren,
      'canRemoveMyDriveParent': canRemoveMyDriveParent,
      'canRename': canRename,
      'canShare': canShare,
      'canTrash': canTrash,
      'canUntrash': canUntrash,
    };
  }
}
