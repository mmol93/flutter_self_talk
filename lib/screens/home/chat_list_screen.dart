import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:self_talk/widgets/home/item_chat_room_list.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListScreen();
}

class _ChatListScreen extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final chatData = ref.watch(chatViewModelProvider);
    return Scaffold(
      body: Expanded(
          child: chatData != null
              ? Column(
                  children: chatData.chatList!.entries
                      .map((chatInfo) => ChatRoomListItem(chat: chatInfo.value))
                      .toList(),
                )
              : Text("생성된 채팅방이 없습니다.")),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 35),
        child: FloatingActionButton(
          child: Icon(Icons.chat_bubble),
          onPressed: () {
            viewModel.createChatList();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
