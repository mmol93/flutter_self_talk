// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      chatList: (json['chatList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Chat.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'chatList': instance.chatList,
    };

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      lastMessage: json['lastMessage'] as String?,
      alarmOnOff: json['alarmOnOff'] as bool? ?? true,
      title: json['title'] as String,
      messageList: (json['messageList'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatMember: (json['chatMember'] as List<dynamic>)
          .map((e) => Friend.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiedDate: Chat._fromDateJson((json['modifiedDate'] as num).toInt()),
    )..notification = json['notification'] == null
        ? null
        : Noti.fromJson(json['notification'] as Map<String, dynamic>);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'title': instance.title,
      'messageList': instance.messageList,
      'chatMember': instance.chatMember,
      'notification': instance.notification,
      'lastMessage': instance.lastMessage,
      'modifiedDate': Chat._toDateJson(instance.modifiedDate),
      'alarmOnOff': instance.alarmOnOff,
    };

Noti _$NotiFromJson(Map<String, dynamic> json) => Noti(
      id: json['id'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$NotiToJson(Noti instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      messageTime: DateTime.parse(json['messageTime'] as String),
      message: json['message'] as String,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      isMe: json['isMe'] as bool,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'messageTime': instance.messageTime.toIso8601String(),
      'message': instance.message,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'isMe': instance.isMe,
    };

const _$MessageTypeEnumMap = {
  MessageType.message: 'message',
  MessageType.date: 'date',
  MessageType.state: 'state',
};
