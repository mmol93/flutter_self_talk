import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/friend.dart';
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
    ref.listen(friendViewModelProvider, (previous, next) { });
    final friends = ref.watch(friendViewModelProvider);

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
                "친구 (하단의 친구 아이콘을 눌러서 추가하세요.)",
                style: TextStyle(fontSize: 10, color: Colors.blueGrey),
              ),
            ),
            Container(
              height: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 5),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: FriendItem(
                    friends:
                    Friend(id: "sdf", name: "name1", message: "messsage1"),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 0.5,
              ),
              itemCount: friends.length,
            ),
            Container(
              height: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey.withOpacity(0.5),
            )
          ],
        )
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 35),
        child: FloatingActionButton(
          child: const Icon(Icons.person),
          onPressed: () async {
            viewModel.insertFriend(Friend(id: "id", name: "name", message: "", profileImgPath: ""));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
