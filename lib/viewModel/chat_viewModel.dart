import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/repository/adaptive_ads_repository.dart';
import 'package:self_talk/repository/chat_repository.dart';
import 'package:self_talk/utils/Typedefs.dart';

final chatViewModelProvider = StateNotifierProvider.autoDispose<ChatViewModel, ChatList?>(
    (ref) => ChatViewModel(ChatRepository(), AdaptiveAdsRepository()));

// ChatList 예시
ChatList dummyChatList = ChatList(chatRoom: {
  "abcd1": Chat(
    lastMessage: "마지막 메시지",
    chatRoomName: '친구들과의 채팅1',
    messageList: [
      Message(
        friendId: '3',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
        notSeenMemberNumber: 0,
      ),
      Message(
        friendId: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
        notSeenMemberNumber: 0,
      ),
    ],
    chatMembers: [
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
    alarmOnOff: 1,
    chatRoomName: '친구들과의 채팅2',
    messageList: [
      Message(
        friendId: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
        notSeenMemberNumber: 0,
      ),
      Message(
        friendId: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
        notSeenMemberNumber: 0,
      ),
    ],
    chatMembers: [
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
    alarmOnOff: 0,
    chatRoomName: '친구들과의 채팅3',
    messageList: [
      Message(
        friendId: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
        notSeenMemberNumber: 0,
      ),
      Message(
        friendId: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
        notSeenMemberNumber: 0,
      ),
    ],
    chatMembers: [
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
    lastMessage: "마지막 메시지4",
    alarmOnOff: 0,
    chatRoomName: '친구들과의 채팅4',
    modifiedChatRoomImg: "",
    messageList: [
      Message(
        friendId: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
        notSeenMemberNumber: 0,
      ),
      Message(
        friendId: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
        notSeenMemberNumber: 0,
      ),
    ],
    chatMembers: [
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
    alarmOnOff: 0,
    chatRoomName: '친구들과의 채팅5',
    messageList: [
      Message(
        friendId: '1',
        messageTime: DateTime.now(),
        message: '안녕하세요',
        messageType: MessageType.message,
        isMe: true,
        notSeenMemberNumber: 0,
      ),
      Message(
        friendId: '2',
        messageTime: DateTime.now().add(const Duration(minutes: 1)),
        message: '반갑습니다',
        messageType: MessageType.message,
        isMe: false,
        notSeenMemberNumber: 0,
      ),
    ],
    chatMembers: [
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

class ChatViewModel extends StateNotifier<ChatList?> {
  final ChatRepository _chatRepository;
  final AdaptiveAdsRepository _adaptiveAdsRepository;
  bool isShowAds = true;

  ChatViewModel(this._chatRepository, this._adaptiveAdsRepository) : super(null) {
    getChatList();
  }

  void getChatList() async {
    isShowAds = await _adaptiveAdsRepository.isOverAdaptiveAdsTime();
    state = await _chatRepository.readChatList();
  }

  /// 채팅 리스트 양식 만들기 = 채팅 초기화
  void createChatList() async {
    isShowAds = await _adaptiveAdsRepository.isOverAdaptiveAdsTime();
    _chatRepository.createChatList(dummyChatList).then((value) => getChatList());
  }

  /// 채팅방 자체를 만듬(새로운 채팅방 만들기 등...)
  void createChatRoom(Map<ChatRoomUniqueId, Chat> chatRoom) async {
    _chatRepository.createChatRoom(chatRoom).then((value) => getChatList());
  }

  /// 해당 채팅방에 메시지 추가하기
  void addMessage({
    required String chatId,
    required Message message,
    required bool notSameSpeaker,
  }) async {
    _chatRepository.addMessage(chatId, message, notSameSpeaker).then((value) => getChatList());
  }

  /// 해당 채팅방에 새 멤버 초대하기
  void inviteNewMember({
    required String chatId,
    required List<Friend> invitedFriendList,
    required Message inviteMessage,
  }) async {
    _chatRepository
        .inviteNewMember(
          chatId: chatId,
          invitedFriendList: invitedFriendList,
          inviteMessage: inviteMessage,
        )
        .then((value) => getChatList());
  }

  /// 해당 채팅방의 이름을 변경
  void changeChatRoomName({
    required String chatId,
    required String newChatRoomName,
  }) {
    _chatRepository
        .changeChatRoomName(chatId: chatId, newChatRoomName: newChatRoomName)
        .then((value) => getChatList());
  }

  /// 해당 채팅방에서 친구가 나감
  void leaveFriend({
    required String chatId,
    required Friend leaveFriend,
    required Message inviteMessage,
  }) async {
    _chatRepository
        .leaveChatRoom(
          chatId: chatId,
          leaveFriend: leaveFriend,
          inviteMessage: inviteMessage,
        )
        .then((value) => getChatList());
  }

  /// 해당 채팅방에서 특정 메시지 삭제하기
  void deleteMessage({
    required String chatId,
    required int messageIndex,
    required Message message,
  }) async {
    _chatRepository.deleteMessage(chatId, messageIndex, message).then((value) => getChatList());
  }

  /// 해당 채팅방 삭제하기
  void removeChatRoom({required String chatId}) async {
    _chatRepository.removeChatRoom(chatId: chatId).then((value) => getChatList());
  }

  /// 해당 채팅방을 복사한다.
  void copyChatRoom({required String chatId}) async {
    _chatRepository.copyChatRoom(chatId: chatId).then((value) => getChatList());
  }

  /// 특정 채팅방의 특정 채팅 수정하기
  void updateMessage({
    required String chatId,
    required int messageIndex,
    required Message message,
  }) async {
    _chatRepository.updateMessage(chatId, messageIndex, message).then((value) => getChatList());
  }

  /// 해당 채팅방의 공지 업데이트 하기
  void updateChatNoti({required String chatId, required Noti? chatNoti}) async {
    _chatRepository.updateNoti(chatId, chatNoti).then((value) => getChatList());
  }

  /// 해당 메시지를 삭제된 매시지로 만들기
  void makeMessageDeleted({
    required String chatId,
    required int messageIndex,
  }) {
    _chatRepository.makeMessageDeleted(chatId, messageIndex).then((value) => getChatList());
  }
}
