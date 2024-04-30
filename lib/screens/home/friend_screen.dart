import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/navigator/slide_navigator.dart';
import 'package:self_talk/screens/home/add_friend_screen.dart';
import 'package:self_talk/viewModel/friend_viewModel.dart';
import '../../widgets/home/item_friend.dart';

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendScreen();
}

class _FriendScreen extends ConsumerState<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(friendViewModelProvider.notifier);
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
                border: Border.all(color: Colors.grey.shade300, width: 0.5)),
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
                ),
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
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: FriendItem(
                      friend: Friend(
                        id: friends[index].id,
                        name: friends[index].name,
                        message: friends[index].message,
                        profileImgPath: friends[index].profileImgPath,
                      ),
                    ),
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
            slideNavigateStateful(context, AddFriendScreen(
              friend: (createdFriend) {
                if (createdFriend.me == 1) {
                  // 내 프로필로 설정했다면 기존 '내 프로필'을 친구로 바꿔야한다.
                  viewModel.updateMyProfile();
                }
                viewModel.insertFriend(createdFriend);
              },
            ));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
