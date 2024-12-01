import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/friend_repository.dart';

final friendViewModelProvider =
    StateNotifierProvider.autoDispose<FriendViewModel, List<Friend>>(
        (ref) => FriendViewModel(FriendRepository()));

class FriendViewModel extends StateNotifier<List<Friend>> {
  final FriendRepository _friendRepository;

  FriendViewModel(this._friendRepository) : super([]) {
    getFriend();
  }

  void getFriend() async {
    state = await _friendRepository.getFriends();
  }

  void insertFriend(Friend friend) {
    _friendRepository.insertFriend(friend).then((value) {
      state = [...state, friend];
    });
  }

  void updateFriend(Friend friend) {
    _friendRepository.updateFriend(friend).then((value) {
      getFriend();
    });
  }

  void deleteFriend(String id) {
    _friendRepository.deleteFriend(id).then((value) {
      getFriend();
    });
  }

  void changeMeToFriend() {
    _friendRepository.changeMeToFriend().then((value) {
      getFriend();
    });
  }

  void updateAsMe(Friend friend) {
    friend.me = 1; // '나'로 변경
    _friendRepository.changeMeToFriend().then((value) => updateFriend(friend));
  }
}
