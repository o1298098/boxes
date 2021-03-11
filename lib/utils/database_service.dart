import 'package:boxes/models/drive_file.dart';
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
  initDatabase() async {
    //deleteDatabase(join(await getDatabasesPath(), 'boxes_database.db'));
    database = openDatabase(
      join(await getDatabasesPath(), 'boxes_database.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute(
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
            modifiedDate TEXT)
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
}
