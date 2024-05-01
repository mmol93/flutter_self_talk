import 'package:self_talk/database/friend_database.dart';
import 'package:self_talk/models/friend.dart';

class FriendRepository {
  final _friendDb = FriendDatabase.db;

  Future<List<Friend>> getFriends() async {
    return _friendDb.getFriends();
  }

  Future<void> insertFriend(Friend friend) async {
    return _friendDb.insertFriend(friend);
  }

  Future<void> updateFriend(Friend friend) async {
    return _friendDb.updateFriend(friend);
  }

  Future<void> deleteFriend(String id) async {
    return _friendDb.deleteFriend(id);
  }

  Future<void> changeMeToFriend() async {
    return _friendDb.changeMeToFriend();
  }
}
