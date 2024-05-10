import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListScreen();
}

class _ChatListScreen extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final chatList = ref.watch(chatViewModelProvider);
    return Scaffold(
      body: Expanded(
        child: Column(
          children: [
            if (chatList != null) Text("has List") else Text("Not List"),
          ],
        ),
      ),
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
