import 'models.dart';

class ModelFactory {
  static T generate<T>(json) {
    switch (T.toString()) {
      case 'User':
        return User.fromJson(json) as T;
      case 'UserDrive':
        return UserDrive.fromJson(json) as T;
      case 'DropboxFiles':
        return DropboxFiles.fromJson(json) as T;
      case "GoogleFiles":
        return GoogleFiles.fromJson(json) as T;
      case "DropBoxThumbnails":
        return DropBoxThumbnails.fromJson(json) as T;
      case 'Metadata':
        return Metadata.fromJson(json) as T;
      default:
        return json;
    }
  }
}
