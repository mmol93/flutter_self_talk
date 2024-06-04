import 'dart:convert';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/utils/Typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  Future<SharedPreferences> _initPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// 채팅 리스트 양식 만들기 = 채팅 초기화
  Future<void> createChatList(ChatList chatList) async {
    final prefs = await _initPrefs();
    final chatListJson = jsonEncode(chatList.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  /// 특정 채팅방의 특정 채팅 수정하기
  Future<void> updateMessage(
    String chatId,
    int messageIndex,
    Message message,
  ) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      chatData.chatRoom![chatId]!.messageList?[messageIndex] = message;
      await updateChatList(chatData);
    }
  }

  Future<void> addMessage(
    String chatId,
    Message message,
  ) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final targetChat = chatData.chatRoom![chatId]!;
      if (targetChat.messageList == null) {
        targetChat.messageList = [message];
      }else {
        targetChat.messageList?.add(message);
      }
      targetChat.lastMessage = message.message;
      targetChat.modifiedDate = DateTime.now();
      await updateChatList(chatData);
    }
  }

  /// 모든 채팅방 데이터 읽어오기
  Future<ChatList?> readChatList() async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatList = ChatList.fromJson(jsonDecode(chatListJson));
      return chatList;
    }
    return null;
  }

  /// 모든 채팅 리스트 업데이트
  Future<void> updateChatList(ChatList chatRoom) async {
    final prefs = await _initPrefs();
    final chatListJson = jsonEncode(chatRoom.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  // TODO: 미완성 - 특정 채팅방을 삭제하게 해야함(지금은 모든 채팅 데이터를 삭제하게 되있음...)
  Future<void> deleteChatList() async {
    final prefs = await _initPrefs();
    await prefs.remove('chatList');
  }

  /// 채팅방 자체를 만듬(새로운 채팅방 만들기 등...)
  Future<void> createChatRoom(Map<ChatRoomUniqueId, Chat> chatRoom) async {
    final prefs = await _initPrefs();
    final currentChatListJson = prefs.getString('chatList');

    if (currentChatListJson == null) {
      await createChatList(ChatList(chatRoom: chatRoom));
    }

    if (currentChatListJson != null) {
      final currentChatList =
          ChatList.fromJson(jsonDecode(currentChatListJson));
      // 새롭게 생성되는 단톡방은 무조건 한 번에 하나만 생성하기 때문에 전부 first로 해도 상관없다.
      currentChatList.chatRoom![chatRoom.keys.first] = chatRoom.values.first;
      final chatListJson = jsonEncode(currentChatList.toJson());
      await prefs.setString('chatList', chatListJson);
    }
  }
}
