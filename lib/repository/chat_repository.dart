import 'dart:convert';

import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/utils/Typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  // SharedPreferences 인스턴스를 저장할 변수
  SharedPreferences? _prefs;

  // SharedPreferences 초기화 메서드
  Future<SharedPreferences> _initPrefs() async {
    // 이미 초기화되어 있다면 캐시된 인스턴스 반환
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
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
            (MessageType.message == message.messageType ||
                MessageType.calling == message.messageType ||
                MessageType.callCut == message.messageType)) {
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
          if (message.messageType == MessageType.message ||
              message.messageType == MessageType.calling ||
              message.messageType == MessageType.callCut) {
            chatData.chatRoom![chatId]?.lastMessage = message.message;
            await updateChatList(chatData);
            break;
          }
        }
      }
    }
  }

  /// Chat에서 Noti(=공지) 부분을 업데이트 한다.
  Future<void> updateNoti(String chatId, Noti? chatNoti) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      chatData.chatRoom![chatId]?.notification = chatNoti;
      await updateChatList(chatData);
    }
  }

  /// 해당 메시지를 삭제된 메시지로 만들기
  Future<void> makeMessageDeleted(String chatId, int messageIndex) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      chatData.chatRoom![chatId]?.messageList![messageIndex].messageType = MessageType.deleted;
      chatData.chatRoom![chatId]?.messageList![messageIndex].imagePath = null;
      chatData.chatRoom![chatId]?.messageList![messageIndex].message = "삭제된 메시지입니다.";
      await updateChatList(chatData);
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
        if (message.messageType == MessageType.message) {
          targetChatRoom.messageList?.forEach((message) {
            if (message.notSeenMemberNumber > 0 && notSameSpeaker) {
              message.notSeenMemberNumber -= 1;
            }
          });
        }
        targetChatRoom.messageList?.add(message);
      }
      if (message.messageType == MessageType.message) {
        // 이미지면 마지막 메시지에 사진에 대한 메시지를 넣는다.
        if (message.imagePath != null) {
          targetChatRoom.lastMessage = "사진을 보냈습니다.";
        } else {
          // 마지막 메시지를 업데이트 해준다.
          targetChatRoom.lastMessage = message.message;
        }
        targetChatRoom.modifiedDate = DateTime.now();
      } else if (message.messageType == MessageType.calling ||
          message.messageType == MessageType.callCut) {
        // 그룹 콜에 대한 마지막 메시지 삽입
        if (message.message.isEmpty && message.messageType == MessageType.calling) {
          targetChatRoom.lastMessage = "그룹콜 해요";
        } else if ((message.message.isEmpty && message.messageType == MessageType.callCut)) {
          targetChatRoom.lastMessage = "취소";
        } else {
          targetChatRoom.lastMessage = message.message;
        }
      }
      await updateChatList(chatData);
    }
  }

  /// 채팅방 이름 바꾸기
  Future<void> changeChatRoomName({required String chatId, required String newChatRoomName}) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');
    if (chatListJson != null) {
      final chatList = ChatList.fromJson(jsonDecode(chatListJson));
      final targetChatRoom = chatList.chatRoom![chatId];
      targetChatRoom?.chatRoomName = newChatRoomName;

      updateChatList(chatList);
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

  /// 채팅방에 새로운 멤버 초대하기
  Future<void> inviteNewMember({
    required String chatId,
    required List<Friend> invitedFriendList,
    required Message inviteMessage,
  }) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');

    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final targetChatRoom = chatData.chatRoom![chatId]!;

      for (Friend invitedFriend in invitedFriendList) {
        targetChatRoom.chatMembers.add(invitedFriend);
      }

      // 초대 이후 초대되었다는 메시지를 업데이트 한다.
      if (targetChatRoom.messageList == null) {
        targetChatRoom.messageList = [inviteMessage];
      } else {
        targetChatRoom.messageList?.add(inviteMessage);
      }

      updateChatList(chatData);
    }
  }

  /// 채팅방의 멤버 1명을 나간 처리 한다.
  Future<void> leaveChatRoom({
    required String chatId,
    required Friend leaveFriend,
    required Message inviteMessage,
  }) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');

    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      final targetChatRoom = chatData.chatRoom![chatId]!;

      targetChatRoom.chatMembers.removeWhere((friend) => friend.id == leaveFriend.id);

      // 초대 이후 나갔다는 메시지를 업데이트 한다.
      if (targetChatRoom.messageList == null) {
        targetChatRoom.messageList = [inviteMessage];
      } else {
        targetChatRoom.messageList?.add(inviteMessage);
      }
      updateChatList(chatData);
    }
  }

  /// 모든 채팅 리스트 업데이트
  /// 일반적으로 어떤 업데이트 실시 후 해당 함수를 사용해 UI 및 데이터 갱신
  Future<void> updateChatList(ChatList chatRoom) async {
    final prefs = await _initPrefs();
    final chatListJson = jsonEncode(chatRoom.toJson());
    await prefs.setString('chatList', chatListJson);
  }

  /// 특정 채팅방을 삭제한다.
  Future<void> removeChatRoom({required String chatId}) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');

    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      chatData.chatRoom!.remove(chatId);
      updateChatList(chatData);
    }
  }

  /// 특정 채팅방을 복사한다.
  Future<void> copyChatRoom({required String chatId}) async {
    final prefs = await _initPrefs();
    final chatListJson = prefs.getString('chatList');

    if (chatListJson != null) {
      final chatData = ChatList.fromJson(jsonDecode(chatListJson));
      // 해당 채팅방 데이터를 복사한다. (복사할 때 채팅방 이름 마지막에 "_복사본"을 붙인다.
      final copiedChatRoomData = chatData.chatRoom![chatId]!
          .copyChatRoom(chatRoomName: "${chatData.chatRoom![chatId]!.chatRoomName}_복사본");
      final uniqueChatRoomId = const Uuid().v4();

      // 채팅방 ID만 새롭게 추가하여 만든다.
      chatData.chatRoom!.addAll({uniqueChatRoomId: copiedChatRoomData});
      updateChatList(chatData);
    }
  }

  /// 채팅방 자체를 만듬(새로운 채팅방 만들기 등...)
  Future<void> createChatRoom(Map<ChatRoomUniqueId, Chat> chatRoom) async {
    final prefs = await _initPrefs();
    final currentChatListJson = prefs.getString('chatList');

    if (currentChatListJson == null) {
      await createChatList(ChatList(chatRoom: chatRoom));
    }

    if (currentChatListJson != null) {
      final currentChatList = ChatList.fromJson(jsonDecode(currentChatListJson));
      // 새롭게 생성되는 단톡방은 무조건 한 번에 하나만 생성하기 때문에 전부 first로 해도 상관없다.
      currentChatList.chatRoom![chatRoom.keys.first] = chatRoom.values.first;
      final chatListJson = jsonEncode(currentChatList.toJson());
      await prefs.setString('chatList', chatListJson);
    }
  }
}
