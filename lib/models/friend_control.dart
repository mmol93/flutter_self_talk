enum FriendControl {
  setAsMe,
  chat1on1,
  modifyProfile,
  deleteItself,
  chatMulti;
}

class FriendControlResult {
  final FriendControl friendControl;

  FriendControlResult({required this.friendControl});
}