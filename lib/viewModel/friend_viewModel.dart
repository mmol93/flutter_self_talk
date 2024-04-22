import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/database/friend_database.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/friend_repository.dart';

final friendViewModelProvider = StateNotifierProvider<FriendViewModel, List<Friend>>((ref) => FriendViewModel());
final friendRepositoryProvider = Provider((ref) => FriendRepository());

class FriendViewModel extends StateNotifier<List<Friend>> {

  FriendViewModel() : super([]);

  void getFriend() async {
    state = await FriendDatabase.db.getFriends();
  }

  void insertFriend(Friend friend) {
    FriendDatabase.db.insertFriend(friend);
    state = [...state, friend];
  }
}