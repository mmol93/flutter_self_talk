import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/chat_repository.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatList?>(
    (ref) => ChatViewModel(ChatRepository()));

// ChatList 예시
ChatList dummyChatList = ChatList(
  chatList: [
    Chat(
      title: '친구들과의 채팅',
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
  ],
);

class ChatViewModel extends StateNotifier<ChatList?> {
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
}
