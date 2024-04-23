import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/friend_repository.dart';

final friendViewModelProvider = StateNotifierProvider<FriendViewModel, List<Friend>>((ref) => FriendViewModel(FriendRepository()));

class FriendViewModel extends StateNotifier<List<Friend>> {
  final FriendRepository _friendRepository;

  FriendViewModel(this._friendRepository) : super([]) {
    getFriend();
  }

  void getFriend() async {
    state = await _friendRepository.getFriends();
  }

  void insertFriend(Friend friend) {
    _friendRepository.insertFriend(friend);
    state = [...state, friend];
  }
}