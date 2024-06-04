import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? chatId;
  const ChatScreen({this.chatId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final String? chatId;

  @override
  void initState() {
    super.initState();
    if (widget.chatId == null) {
      chatId = const Uuid().v4();
    } else {
      chatId = widget.chatId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final wholeChatList = ref.watch(chatViewModelProvider);
    final Chat targetChatData = wholeChatList!.chatRoom![chatId]!;

    return Scaffold(
      backgroundColor: defaultBackground,
      appBar: AppBar(
        backgroundColor: defaultBackground,
        title: Row(
          children: [
            Text(targetChatData.title ?? ""),
            const SizedBox(width: 5),
            Text(
              targetChatData.chatMember.length.toString(),
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          // TODO: 기능 추가 필요
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Text(targetChatData.messageList![index].message);
            },
            itemCount: targetChatData.messageList?.length ?? 0
          ),
          TextButton(
            onPressed: () {
              viewModel.addMessage(
                chatId: chatId ?? "",
                message: Message(
                  friendId: '1',
                  messageTime: DateTime.now().add(const Duration(minutes: 1)),
                  message: '반갑습니다22',
                  messageType: MessageType.message,
                  isMe: false,
                ),
              );
            },
            child: Text("추가하기"),
          )
        ],
      ),
    );
  }
}
