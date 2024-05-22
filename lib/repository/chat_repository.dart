import 'dart:convert';
import 'package:self_talk/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  Future<void> createChatList(ChatRoom chatList) async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = jsonEncode(chatList.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  Future<void> updateChat(String chatId, int messageIndex, Message message) async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatRoom.fromJson(jsonDecode(chatListJson));
      chatData.chatList![chatId]!.messageList[messageIndex] = message;
      await updateChatList(chatData);
    }
  }

  Future<ChatRoom?> readChatList() async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatList = ChatRoom.fromJson(jsonDecode(chatListJson));
      return chatList;
    }
    return null;
  }

  Future<void> updateChatList(ChatRoom chatRoom) async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = jsonEncode(chatRoom.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  Future<void> deleteChatList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatList');
  }
}
