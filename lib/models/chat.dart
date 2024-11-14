import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/utils/Typedefs.dart';
import 'package:uuid/uuid.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatList {
  final Map<ChatRoomUniqueId, Chat>? chatRoom;

  ChatList({this.chatRoom});

  factory ChatList.fromJson(Map<String, dynamic> json) => _$ChatListFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListToJson(this);
}

@JsonSerializable()
class Chat {
  /// 채팅 타이틀
  String? chatRoomName;

  /// 채팅 내용
  List<Message>? messageList;

  /// 채팅하고 있는 멤버
  final List<Friend> chatMembers;

  /// 채팅에 있는 공지 사항 내용
  Noti? notification;

  /// 최근 메시지
  String? lastMessage;

  /// 해당 채팅의 제일 최근 수정된 날짜 - 메시지만 카운트함
  @JsonKey(fromJson: _fromDateJson, toJson: _toDateJson)
  DateTime modifiedDate;

  /// 알림 On/Off 아이콘 표시
  /// 0: Off
  /// 1: On
  int alarmOnOff;

  final String? modifiedChatRoomImg;

  Chat({
    this.lastMessage,
    this.alarmOnOff = 1,
    this.modifiedChatRoomImg,
    this.notification,
    required this.chatRoomName,
    required this.messageList,
    required this.chatMembers,
    required this.modifiedDate,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime _fromDateJson(int millisecondsSinceEpoch) =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  static int _toDateJson(DateTime date) => date.millisecondsSinceEpoch;

  String getModifiedDateToString() => DateFormat('yyyy-MM-dd').format(modifiedDate);

  /// 해당 단톡방에서 내가 아닌 친구의 사진 경로를 가져온다.
  /// 그렇기 때문에 항상 같은 친구의 사진을 가져오는게 아님.
  String getaFriendProfilePath() {
    try {
      return chatMembers.firstWhere((friend) => friend.me == 0).profileImgPath;
    } catch (e) {
      return Strings.defaultProfileImgPath;
    }
  }

  /// 현재 채팅방 데이터를 복사한다.
  Chat copyChatRoom({
    String? chatRoomName,
    List<Message>? messageList,
    List<Friend>? chatMembers,
    Noti? notification,
    String? lastMessage,
    DateTime? modifiedDate,
    int? alarmOnOff,
    String? modifiedChatRoomImg,
  }) {
    return Chat(
      lastMessage: lastMessage ?? this.lastMessage,
      chatRoomName: chatRoomName ?? this.chatRoomName,
      messageList: messageList ?? this.messageList,
      chatMembers: chatMembers ?? this.chatMembers,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      alarmOnOff: alarmOnOff ?? this.alarmOnOff,
      notification: notification ?? this.notification,
      modifiedChatRoomImg: modifiedChatRoomImg ?? this.modifiedChatRoomImg,
    );
  }

  /// 빈 채팅방을 만든다.
  Chat createEmptyChatRoom() {
    // 최초의 채팅방 이름 만들기
    String initTitle = "";
    for (var indexedValue in chatMembers.indexed) {
      if (indexedValue.$2.me == 0) {
        // 자기 자신을 이미 제외했기 때문에 -1로 한다.
        if (indexedValue.$1 != chatMembers.length - 1) {
          // 마지막 요소가 아닐 때
          initTitle = "$initTitle${indexedValue.$2.name}, ";
        } else {
          // 마지막 요소일 때
          initTitle = "$initTitle${indexedValue.$2.name}";
        }
      }
    }

    // 마지막에 ,가 있으면 이걸 삭제한다.
    if (initTitle.endsWith(", ")) initTitle = initTitle.substring(0, initTitle.lastIndexOf(","));

    return Chat(
        chatRoomName: initTitle,
        messageList: null,
        chatMembers: chatMembers,
        modifiedDate: DateTime.now());
  }

  String? getFriendName(String friendId) {
    try {
      return chatMembers.firstWhere((friend) => friend.id == friendId).name;
    } catch (e) {
      return null;
    }
  }

  /// 채팅의 메시지 버블에서 날짜를 표시할지 말지 결정
  bool shouldShowDate(int targetIndex) {
    // ** 아래 조건 순서 바꾸면 안됨!! **
    DateFormat formatter = DateFormat('yyyy.MM.dd-HH:mm');

    // 채팅 내역의 마지막 메시지면 무조건 날짜를 표시
    if (messageList?.isNotEmpty == true && targetIndex == messageList!.length - 1) return true;

    // 다음 채팅의 사람이 서로 다르면 날짜 표시하기
    if (messageList![targetIndex + 1].friendId != messageList![targetIndex].friendId) return true;

    if (messageList?.isNotEmpty == true &&
        targetIndex + 1 <= messageList!.length - 1 &&
        targetIndex - 1 >= 0) {
      // 직적 메시지와 날짜 같음 && 다음 메시지와 날짜 다름 = true
      if (formatter.format(messageList![targetIndex - 1].messageTime) ==
              formatter.format(messageList![targetIndex].messageTime) &&
          formatter.format(messageList![targetIndex + 1].messageTime) !=
              formatter.format(messageList![targetIndex].messageTime)) return true;
    }

    if (messageList?.isNotEmpty == true && targetIndex + 1 <= messageList!.length - 1) {
      // 다음 메시지를 보고 날짜가 같으면 false
      if (formatter.format(messageList![targetIndex + 1].messageTime) ==
          formatter.format(messageList![targetIndex].messageTime)) return false;
    }

    if (targetIndex - 1 >= 0 && messageList?.isNotEmpty == true) {
      // 직전 메시지와 날짜가 다르거나 보내는 사람이 다르면 true를 반환한다.
      return formatter.format(messageList![targetIndex].messageTime) !=
              formatter.format(messageList![targetIndex - 1].messageTime) ||
          messageList![targetIndex - 1].friendId != messageList![targetIndex].friendId;
    }

    /// 첫 메시지 같은 경우에 무조건 시간을 표시해야하니 true
    return true;
  }

  /// 채팅의 메시지 버블에서 Tail이 달린 버블을 사용할지 그냥 둥근 버블을 사용할지 결정
  bool shouldUseTailBubble(int targetIndex) {
    if (targetIndex - 1 >= 0 && messageList?.isNotEmpty == true) {

      DateFormat formatter = DateFormat('yyyy.MM.dd-HH:mm');
      // 직전 메시지와 날짜가 다르거나 보내는 사람이 다르면 true를 반환한다.
      return formatter.format(messageList![targetIndex].messageTime) !=
              formatter.format(messageList![targetIndex - 1].messageTime) ||
          messageList![targetIndex - 1].friendId != messageList![targetIndex].friendId;
    }

    /// 첫 메시지 같은 경우에 무조건 시간을 표시해야하니 true
    return true;
  }

  /// 현재 채팅방의 공지를 업데이트 한다.
  Noti? createChatRoomNoti(String message, String userName) {
    final id = const Uuid().v4();
    notification = Noti(id: id, message: message, userName: userName);
    return notification;
  }

  /// Noti의 접음 / 펼침 상태를 변경한다.
  Noti? changeNotiFoldStatus() {
    if (notification != null) notification!.folded = !notification!.folded;
    return notification;
  }

  /// Noti를 최소화 상태를 변경한다.
  Noti? changeNotiMinimizeStatus() {
    if (notification != null) {
      notification!.isMinimize = !notification!.isMinimize;
    }
    return notification;
  }
}

@JsonSerializable()
class Noti {
  bool folded;
  bool isMinimize;
  final String id;
  final String userName;
  final String message;

  Noti(
      {this.folded = true,
      this.isMinimize = false,
      required this.userName,
      required this.id,
      required this.message});

  factory Noti.fromJson(Map<String, dynamic> json) => _$NotiFromJson(json);

  Map<String, dynamic> toJson() => _$NotiToJson(this);
}

@JsonSerializable()
class Message {
  final String friendId;
  DateTime messageTime;
  String message;
  String? secondMessage;
  final MessageType messageType;
  final bool isMe;
  int notSeenMemberNumber = 0;
  String? imagePath;
  bool isFailed;

  Message({
    required this.friendId,
    required this.messageTime,
    required this.message,
    required this.messageType,
    required this.isMe,
    required this.notSeenMemberNumber,
    this.isFailed = false,
    this.secondMessage,
    this.imagePath,
  });

  Message copyWith({
    String? friendId,
    DateTime? messageTime,
    String? message,
    String? secondMessage,
    MessageType? messageType,
    bool? isMe,
    int? notSeenMemberNumber,
    String? imagePath,
    bool? isFailed,
  }) {
    return Message(
        friendId: friendId ?? this.friendId,
        messageTime: messageTime ?? this.messageTime,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        isMe: isMe ?? this.isMe,
        notSeenMemberNumber: notSeenMemberNumber ?? this.notSeenMemberNumber,
        imagePath: imagePath ?? this.imagePath,
        isFailed: isFailed ?? this.isFailed);
  }

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

/// message: 일반적인 메시지
/// call: 그룹콜, 개인콜에 대한 메시지
/// date: 날짜 구분선
/// state: 초대, 나가기 등 상태에 관한 메시지
enum MessageType { message, calling, callCut, date, state }
