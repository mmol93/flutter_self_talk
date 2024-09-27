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
      final messages = chatData.chatRoom![chatId]!.messageList;
      messages?[messageIndex] = message;

      // 변경한게 마지막 메시지 + 일반 메시지 타입이면 채팅방의 마지막 메시지도 바꿔야한다.
      if (messages != null) {
        if (messages.length - 1 == messageIndex &&
            MessageType.message == message.messageType) {
          chatData.chatRoom![chatId]?.lastMessage = message.message;
        }
      }

      await updateChatList(chatData);
    }
  }

  /// 메시지를 삭제 후에 마지막 메시지를 업데이트 한다.
  Future<void> updateLastMessage(String chatId) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final messages = chatData.chatRoom![chatId]!.messageList;

      if (messages != null) {
        for (var message in messages.reversed) {
          // 뒤에서 부터 확인하니 리소스도 그렇게 들지 않을 것임
          if (message.messageType == MessageType.message) {
            chatData.chatRoom![chatId]?.lastMessage = message.message;
            await updateChatList(chatData);
            break;
          }
        }
      }
    }
  }

  /// 해당 채팅방에서 특정 메시지 삭제하기
  Future<void> deleteMessage(
    String chatId,
    int messageIndex,
    Message message,
  ) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final currentChatRoom = chatData.chatRoom![chatId]!;
      currentChatRoom.messageList?.removeAt(messageIndex);
      await updateChatList(chatData);
      await updateLastMessage(chatId);
    }
  }

  /// 해당 채팅방에 메시지 추가하기
  Future<void> addMessage(
    String chatId,
    Message message,
    bool notSameSpeaker,
  ) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final targetChatRoom = chatData.chatRoom![chatId]!;
      if (targetChatRoom.messageList == null) {
        targetChatRoom.messageList = [message];
      } else {
        targetChatRoom.messageList?.forEach((message) {
          if (message.notSeenMemberNumber > 0 && notSameSpeaker) {
            message.notSeenMemberNumber -= 1;
          }
        });
        targetChatRoom.messageList?.add(message);
      }
      targetChatRoom.lastMessage = message.message;
      targetChatRoom.modifiedDate = DateTime.now();
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
  /// 일반적으로 어떤 업데이트 실시 후 해당 함수를 사용해 UI 및 데이터 갱신
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
