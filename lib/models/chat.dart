import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/utils/Typedefs.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatRoom {
  final Map<ChatRoomUniqueId, Chat>? chatList;

  ChatRoom({this.chatList});

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}

@JsonSerializable()
class Chat {
  /// 채팅 타이틀
  final String title;

  /// 채팅 내용
  final List<Message> messageList;

  /// 채팅하고 있는 멤버
  final List<Friend> chatMember;

  /// 채팅에 있는 공지 사항 내용
  Noti? notification;

  /// 최근 메시지
  final String? lastMessage;

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
    required this.title,
    required this.messageList,
    required this.chatMember,
    required this.modifiedDate,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime _fromDateJson(int millisecondsSinceEpoch) =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  static int _toDateJson(DateTime date) => date.millisecondsSinceEpoch;

  String getModifiedDateToString() =>
      DateFormat('yyyy-MM-dd').format(modifiedDate);

  /// 해당 단톡방에서 내가 아닌 친구의 사진 경로를 가져온다.
  /// 그렇기 때문에 항상 같은 친구의 사진을 가져오는게 아님.
  String getaFriendProfilePath() {
    try {
      return chatMember.firstWhere((friend) => friend.me == 0).profileImgPath;
    } catch(e) {
      return Strings.defaultProfileImgPath;
    }
  }
}

@JsonSerializable()
class Noti {
  final String id;
  final String message;

  Noti({required this.id, required this.message});

  factory Noti.fromJson(Map<String, dynamic> json) => _$NotiFromJson(json);

  Map<String, dynamic> toJson() => _$NotiToJson(this);
}

@JsonSerializable()
class Message {
  final String id;
  final DateTime messageTime;
  final String message;
  final MessageType messageType;
  final bool isMe;

  Message({
    required this.id,
    required this.messageTime,
    required this.message,
    required this.messageType,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

enum MessageType { message, date, state }
