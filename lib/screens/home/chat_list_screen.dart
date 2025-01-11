import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/list_item_model.dart';
import 'package:self_talk/navigator/moving_navigator.dart';
import 'package:self_talk/screens/chat/chat_screen.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:self_talk/widgets/dialog/list_dialog.dart';
import 'package:self_talk/widgets/home/item_chat_room_list.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListScreen();
}

class _ChatListScreen extends ConsumerState<ChatListScreen> {
  /// 채팅룸 아이템을 길게 눌렀을 때 보여줄 Dialog
  void _showChatRoomOptions(
    String chatTitle,
    ChatViewModel viewModel,
    String chatId,
  ) {
    showListDialog(title: chatTitle, context: context, listItemModel: [
      ListItemModel(
        itemTitle: "방 삭제하기",
        clickEvent: () {
          viewModel.removeChatRoom(chatId: chatId);
        },
      ),
      ListItemModel(
        itemTitle: "방 복사하기",
        clickEvent: () {
          viewModel.copyChatRoom(chatId: chatId);
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final chatData = ref.watch(chatViewModelProvider);
    if (isProduction) {
      viewModel.checkFirstInitChat();
    }

    return Scaffold(
      body: chatData != null
          ? Column(
              children: chatData.chatRoom!.entries
                  .map((flattenChatData) => ChatRoomListItem(
                        chat: flattenChatData.value,
                        clickChatRoomListItem: () {
                          centerNavigateStateful(
                            context,
                            ChatScreen(chatId: flattenChatData.key),
                          );
                        },
                        longClickEvent: () {
                          _showChatRoomOptions(
                            flattenChatData.value.chatRoomName ?? "",
                            viewModel,
                            flattenChatData.key,
                          );
                        },
                      ))
                  .toList())
          : const Text("생성된 채팅방이 없습니다."),
      floatingActionButton: !isProduction
          ? Container(
              margin: const EdgeInsets.only(bottom: 50, right: 35),
              child: FloatingActionButton(
                child: const Icon(Icons.chat_bubble),
                onPressed: () {
                  viewModel.initChatList();
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
