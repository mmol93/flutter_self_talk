import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final chatList = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("$chatId"),
      ),
      body: Column(children: [
        Text(chatList!.chatList!["abcd1"]!.first.title),
        TextButton(onPressed: () {}, child: Text("추가하기"))
      ],),
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
