import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({this.chatId, super.key});

  final String? chatId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final String? chatId;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final chatData = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(chatData!.chatRoom![chatId]?.title ?? ""),
      ),
      body: Column(
        children: [
          Text(chatData.chatRoom![chatId]?.messageList?[0].message ?? ""),
          TextButton(
            onPressed: () {
              viewModel.updateMessage(
                chatId: chatId ?? "",
                messageIndex: 0,
                message:  Message(
                  id: '1',
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

  @override
  void initState() {
    super.initState();
    if (widget.chatId == null) {
      chatId = const Uuid().v4();
    } else {
      chatId = widget.chatId;
    }
  }
}
