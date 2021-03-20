import 'package:boxes/models/drive_file.dart';
import 'package:boxes/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Future<Database> database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    initDatabase();
  }
  final _fileTable = 'files';
  final _uploadTable = 'uploadFiles';
  final _driveTable = 'drives';
  initDatabase() async {
    //deleteDatabase(join(await getDatabasesPath(), 'boxes_database.db'));
    database = openDatabase(
      join(await getDatabasesPath(), 'boxes_database.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $_fileTable(
            fileId TEXT PRIMARY KEY,
            driveId INTEGER,
            mimeType TEXT,
            name TEXT,
            size INTEGER,
            mediaMetaData TEXT,
            fileExtension TEXT,
            isDownloadable INTEGER,
            downloadLink TEXT,
            filePath TEXT,
            thumbnailLink TEXT,
            parentId TEXT,
            type TEXT,
            driveType INTEGER,
            modifiedDate TEXT);
            ''',
        );
        await db.execute(
          '''         
          CREATE TABLE $_uploadTable(
            uploadId TEXT PRIMARY KEY,
            sessionId TEXT,
            driveId INTEGER,
            name TEXT,
            stepIndex INTEGER,
            fileSize INTEGER,
            filePath TEXT,
            status INTEGER,
            uploadDate TEXT);
          ''',
        );
        await db.execute(
          '''        
          CREATE TABLE $_driveTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            accessToken TEXT,
            scope TEXT,
            refreshToken TEXT,
            tokenType TEXT,
            driveId TEXT,
            expiresIn TEXT,
            updateTime TEXT,
            driveTypeNavigation TEXT,
            driveUsage TEXT)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertFile(DriveFile file) async {
    final Database db = await database;
    await db.insert(
      _fileTable,
      file.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DriveFile>> getRootFiles(int driveId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_fileTable,
        where: 'driveId = ? and parentId is NULL', whereArgs: [driveId]);
    return List.generate(maps.length, (i) => DriveFile.fromJson(maps[i]));
  }

  Future<List<DriveFile>> getFolderFiles(int driveId, String folderId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_fileTable,
        where: 'driveId = ? and parentId = ?', whereArgs: [driveId, folderId]);
    return List.generate(maps.length, (i) => DriveFile.fromJson(maps[i]));
  }

  Future<void> deleteFile(int fileId) async {
    final db = await database;

    await db.delete(
      _fileTable,
      where: "fileId = ?",
      whereArgs: [fileId],
    );
  }

  Future<void> cleanRoot(int driveId) async {
    final Database db = await database;
    await db.delete(
      _fileTable,
      where: "driveId = ? and parentId is NULL",
      whereArgs: [driveId],
    );
  }

  Future<void> cleanFolder(int driveId, String folderId) async {
    final Database db = await database;
    await db.delete(
      _fileTable,
      where: 'driveId = ? and parentId = ?',
      whereArgs: [driveId, folderId],
    );
  }

  Future<void> insertUploadFile(FileUpload file) async {
    final Database db = await database;
    await db.insert(
      _uploadTable,
      file.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FileUpload>> getUploadList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_uploadTable);
    return List.generate(maps.length, (i) => FileUpload.fromJson(maps[i]));
  }

  Future<void> insertDrive(UserDrive drive) async {
    final Database db = await database;
    await db.insert(
      _driveTable,
      drive.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserDrive>> getDrive(int driveId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_driveTable, where: 'id = ?', whereArgs: [driveId]);
    return List.generate(maps.length, (i) => UserDrive.fromJson(maps[i]));
  }

  Future<List<UserDrive>> getDrvieList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_driveTable);
    return List.generate(maps.length, (i) => UserDrive.fromJson(maps[i]));
  }

  Future<void> deleteDrive(int driveId) async {
    final db = await database;

    await db.delete(
      _driveTable,
      where: "id = ?",
      whereArgs: [driveId],
    );
  }
}
