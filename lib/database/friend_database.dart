import 'package:path/path.dart';
import 'package:self_talk/models/friend.dart';
import 'package:sqflite/sqflite.dart';

class FriendDatabase {
  // 생성자를 private로 생성하기
  FriendDatabase._();

  static final FriendDatabase db = FriendDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'friend_db.db');
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE friend_db (
        id TEXT PRIMARY KEY,
        name TEXT,
        message TEXT,
        profileImgPath TEXT
      )
    ''');
  }

  Future<List<Friend>> getFriends() async {
    final db = await database;
    final maps = await db.query('friend_db');
    return maps.map((map) => Friend.fromMap(map)).toList();
  }

  Future<void> insertFriend(Friend friend) async {
    Database db = await database;
    await db.insert('friend_db', friend.toMap());
  }

  Future updateFriend(Friend friend) async {
    Database db = await database;
    // 해당하는 id를 찾아서 update 한다.
    await db.update('friend_db', friend.toMap(),
        where: 'id = ?', whereArgs: [friend.id]);
  }

  Future deleteFriend(String id) async {
    Database db = await database;
    await db.delete('friend_db', where: 'id = ?', whereArgs: [id]);
  }
}
