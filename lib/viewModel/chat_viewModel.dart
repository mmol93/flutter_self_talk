import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/chat_repository.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatRoom?>(
    (ref) => ChatViewModel(ChatRepository()));

// ChatList 예시
ChatRoom dummyChatList = ChatRoom(chatList: {
  "abcd1": Chat(
    lastMessage: "마지막 메시지",
    title: '친구들과의 채팅1',
    messageList: [
      Message(
        id: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
      ),
      Message(
        id: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
      ),
    ],
    chatMember: [
      Friend(
        id: '1',
        name: '철수',
        message: '안녕하세요',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '2',
        name: '영희',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '3',
        name: '나',
        message: '뭔데 \n이거',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 1,
      ),
    ],
    modifiedDate: DateTime.now().add(const Duration(minutes: 1)),
  ),
  "abcd2": Chat(
    lastMessage: "마지막 메시지",
    alarmOnOff: false,
    title: '친구들과의 채팅2',
    messageList: [
      Message(
        id: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
      ),
      Message(
        id: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
      ),
    ],
    chatMember: [
      Friend(
        id: '1',
        name: '철수',
        message: '안녕하세요',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '2',
        name: '영희',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 1,
      ),
    ],
    modifiedDate: DateTime.now().add(const Duration(minutes: 1)),
  ),
  "abcd3": Chat(
    lastMessage: "마지막 메시지3",
    alarmOnOff: false,
    title: '친구들과의 채팅3',
    messageList: [
      Message(
        id: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
      ),
      Message(
        id: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
      ),
    ],
    chatMember: [
      Friend(
        id: '1',
        name: '철수',
        message: '안녕하세요',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '2',
        name: '영희',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 1,
      ),
      Friend(
        id: '3',
        name: '영춘',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '4',
        name: '영상',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
    ],
    modifiedDate: DateTime.now().add(const Duration(minutes: 1)),
  ),
  "abcd4": Chat(
    lastMessage: "마지막 메시지3",
    alarmOnOff: false,
    title: '친구들과의 채팅3',
    messageList: [
      Message(
        id: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
      ),
      Message(
        id: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
      ),
    ],
    chatMember: [
      Friend(
        id: '1',
        name: '철수',
        message: '안녕하세요',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '2',
        name: '영희',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 1,
      ),
      Friend(
        id: '3',
        name: '영춘',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '4',
        name: '영상',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
    ],
    modifiedDate: DateTime.now().add(const Duration(minutes: 1)),
  ),
  "abcd5": Chat(
    lastMessage: "마지막 메시지3",
    alarmOnOff: false,
    title: '친구들과의 채팅3',
    messageList: [
      Message(
        id: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
      ),
      Message(
        id: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
      ),
    ],
    chatMember: [
      Friend(
        id: '1',
        name: '철수',
        message: '안녕하세요',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '2',
        name: '영희',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 1,
      ),
      Friend(
        id: '3',
        name: '영춘',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '4',
        name: '영상',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
      Friend(
        id: '5',
        name: '영춘',
        message: '반갑습니다',
        profileImgPath: 'assets/images/profile_pic.png',
        me: 0,
      ),
    ],
    modifiedDate: DateTime.now().add(const Duration(minutes: 1)),
  ),
});

class ChatViewModel extends StateNotifier<ChatRoom?> {
  final ChatRepository _chatRepository;

  ChatViewModel(this._chatRepository) : super(null) {
    getChatList();
  }

  void getChatList() async {
    state = await _chatRepository.readChatList();
  }

  void createChatList() async {
    _chatRepository
        .createChatList(dummyChatList)
        .then((value) => getChatList());
  }

  void updateMessage(
      {required String chatId,
      required int messageIndex,
      required Message message}) async {
    _chatRepository
        .updateChat(chatId, messageIndex, message)
        .then((value) => getChatList());
  }
}
