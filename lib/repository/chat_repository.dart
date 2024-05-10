import 'dart:convert';
import 'package:self_talk/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  Future<void> createChatList(ChatList chatList) async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = jsonEncode(chatList.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  Future<ChatList?> readChatList() async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatList = ChatList.fromJson(jsonDecode(chatListJson));
      return chatList;
    }
    return null;
  }

  Future<void> updateChatList(ChatList chatList) async {
    final prefs = await SharedPreferences.getInstance();
    final chatListJson = jsonEncode(chatList.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  Future<void> deleteChatList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatList');
  }
}
