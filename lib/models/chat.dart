import 'package:json_annotation/json_annotation.dart';
import 'package:self_talk/models/friend.dart';
part 'chat.g.dart';

@JsonSerializable()
class ChatRoom {
  final Map<String,Chat>? chatList;

  ChatRoom({this.chatList});

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}

@JsonSerializable()
class Chat {
  // 채팅 타이틀
  final String title;

  // 채팅 내용
  final List<Message> messageList;

  // 채팅하고 있는 멤버
  final List<Friend> chatMember;

  // 채팅에 있는 공지 사항 내용
  Noti? notification;

  // 해당 채팅의 제일 최근 수정된 날짜 - 메시지만 카운트함
  @JsonKey(fromJson: _fromDateJson, toJson: _toDateJson)
  DateTime modifiedDate;

  Chat(
      {required this.title,
      required this.messageList,
      required this.chatMember,
      required this.modifiedDate});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime _fromDateJson(int millisecondsSinceEpoch) =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  static int _toDateJson(DateTime date) => date.millisecondsSinceEpoch;
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

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

enum MessageType { message, date, state }
