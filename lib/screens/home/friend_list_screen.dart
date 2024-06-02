import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/models/friend_control.dart';
import 'package:self_talk/navigator/moving_navigator.dart';
import 'package:self_talk/screens/friend/add_friend_screen.dart';
import 'package:self_talk/screens/friend/update_friend_screen.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:self_talk/viewModel/friend_viewModel.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/home/item_friend.dart';

class FriendListScreen extends ConsumerStatefulWidget {
  const FriendListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendListScreen();
}

class _FriendListScreen extends ConsumerState<FriendListScreen> {
  @override
  Widget build(BuildContext context) {
    final friendViewModel = ref.watch(friendViewModelProvider.notifier);
    final chatViewModel = ref.watch(chatViewModelProvider.notifier);
    final friends = ref
        .watch(friendViewModelProvider)
        .where((friend) => friend.me == 0)
        .toList();
    final myProfile = ref
        .watch(friendViewModelProvider)
        .where((friend) => friend.me == 1)
        .toList();

    return Scaffold(
      body: Expanded(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: const Text(
              "내 프로필",
              style: TextStyle(fontSize: 10, color: Colors.blueGrey),
            ),
          ),
          if (myProfile.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: FriendItem(
                friend: Friend(
                  // 내 프로필은 반드시 1개만 존재하기 때문에
                  id: myProfile.first.id,
                  name: myProfile.first.name,
                  message: myProfile.first.message,
                  profileImgPath: myProfile.first.profileImgPath,
                  me: myProfile.first.me,
                ),
                clickFriendItem: (clickedFriend) {
                  switch (clickedFriend) {
                    case FriendControl.modifyProfile:
                      slideNavigateStateful(
                        context,
                        UpdateFriendScreen(
                          updateFriend: (updatedFriend) {
                            friendViewModel.updateFriend(updatedFriend);
                          },
                          targetFriend: myProfile.first,
                        ),
                      );
                    case FriendControl.deleteItself:
                      friendViewModel.deleteFriend(myProfile.first.id);
                    default:
                  }
                },
              ),
            ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade300, width: 0.5)),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: const Text(
              "친구",
              style: TextStyle(fontSize: 10, color: Colors.blueGrey),
            ),
          ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),
          if (friends.isNotEmpty)
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Friend friend = friends[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: FriendItem(
                        friend: Friend(
                          id: friend.id,
                          name: friend.name,
                          message: friend.message,
                          profileImgPath: friend.profileImgPath,
                          me: friend.me,
                        ),
                        clickFriendItem: (clickedFriendControl) {
                          switch (clickedFriendControl) {
                            case FriendControl.setAsMe:
                              friendViewModel.updateAsMe(friend);

                            case FriendControl.chat1on1:
                              final uuid = const Uuid().v4();
                              final initChat = Chat(
                                title: null,
                                messageList: null,
                                chatMember: [friend, myProfile.first],
                                modifiedDate: DateTime.now(),
                              ).createEmptyChat();
                              chatViewModel.createChatRoom({uuid: initChat});
                              // TODO: 방 만들고 해당 방으로 진입하게 해야함

                            case FriendControl.modifyProfile:
                              slideNavigateStateful(
                                context,
                                UpdateFriendScreen(
                                  updateFriend: (updatedFriend) {
                                    if (updatedFriend.me == 1) {
                                      friendViewModel.updateAsMe(updatedFriend);
                                    } else {
                                      friendViewModel
                                          .updateFriend(updatedFriend);
                                    }
                                  },
                                  targetFriend: friend,
                                ),
                              );

                            case FriendControl.deleteItself:
                              friendViewModel.deleteFriend(friend.id);

                            case FriendControl.chatMulti:
                          }
                        }),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.withOpacity(0.5),
                  thickness: 0.5,
                ),
                itemCount: friends.length,
              ),
            ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      )),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 35),
        child: FloatingActionButton(
          child: const Icon(Icons.person),
          onPressed: () {
            slideNavigateStateful(
              context,
              AddFriendScreen(
                createFriend: (createdFriend) {
                  if (createdFriend.me == 1) {
                    // 내 프로필로 설정했다면 기존 '내 프로필'을 친구로 바꿔야한다.
                    friendViewModel.changeMeToFriend();
                  }
                  friendViewModel.insertFriend(createdFriend);
                },
              ),
            );
          },
        ),
      ),
      // TODO: 테스트용 버튼임, 나중에는 삭제하기
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
