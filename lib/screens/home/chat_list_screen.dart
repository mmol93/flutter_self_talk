import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/navigator/moving_navigator.dart';
import 'package:self_talk/screens/chat/chat_screen.dart';
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
                children: chatData.chatRoom!.entries
                    .map((flattenChatData) => ChatRoomListItem(
                          chat: flattenChatData.value,
                          clickChatRoomListItem: () {
                            centerNavigateStateful(
                                context, ChatScreen(chatId: flattenChatData.key));
                          },
                        ))
                    .toList())
            : const Text("생성된 채팅방이 없습니다."),
      ),
      // TODO: 나중에는 floatButton을 삭제한다.
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 35),
        child: FloatingActionButton(
          child: const Icon(Icons.chat_bubble),
          onPressed: () {
            viewModel.createChatList();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
