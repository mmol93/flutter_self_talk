// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatList _$ChatListFromJson(Map<String, dynamic> json) => ChatList(
      chatRoom: (json['chatRoom'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Chat.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ChatListToJson(ChatList instance) => <String, dynamic>{
      'chatRoom': instance.chatRoom,
    };

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      lastMessage: json['lastMessage'] as String?,
      alarmOnOff: (json['alarmOnOff'] as num?)?.toInt() ?? 1,
      modifiedChatRoomImg: json['modifiedChatRoomImg'] as String?,
      notification: json['notification'] == null
          ? null
          : Noti.fromJson(json['notification'] as Map<String, dynamic>),
      chatRoomName: json['chatRoomName'] as String?,
      messageList: (json['messageList'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatMembers: (json['chatMembers'] as List<dynamic>)
          .map((e) => Friend.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiedDate: Chat._fromDateJson((json['modifiedDate'] as num).toInt()),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chatRoomName': instance.chatRoomName,
      'messageList': instance.messageList,
      'chatMembers': instance.chatMembers,
      'notification': instance.notification,
      'lastMessage': instance.lastMessage,
      'modifiedDate': Chat._toDateJson(instance.modifiedDate),
      'alarmOnOff': instance.alarmOnOff,
      'modifiedChatRoomImg': instance.modifiedChatRoomImg,
    };

Noti _$NotiFromJson(Map<String, dynamic> json) => Noti(
      folded: json['folded'] as bool? ?? true,
      isMinimize: json['isMinimize'] as bool? ?? false,
      userName: json['userName'] as String,
      id: json['id'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$NotiToJson(Noti instance) => <String, dynamic>{
      'folded': instance.folded,
      'isMinimize': instance.isMinimize,
      'id': instance.id,
      'userName': instance.userName,
      'message': instance.message,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      friendId: json['friendId'] as String,
      messageTime: DateTime.parse(json['messageTime'] as String),
      message: json['message'] as String,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      isMe: json['isMe'] as bool,
      notSeenMemberNumber: (json['notSeenMemberNumber'] as num).toInt(),
      secondMessage: json['secondMessage'] as String?,
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'friendId': instance.friendId,
      'messageTime': instance.messageTime.toIso8601String(),
      'message': instance.message,
      'secondMessage': instance.secondMessage,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'isMe': instance.isMe,
      'notSeenMemberNumber': instance.notSeenMemberNumber,
      'imagePath': instance.imagePath,
    };

const _$MessageTypeEnumMap = {
  MessageType.message: 'message',
  MessageType.call: 'call',
  MessageType.date: 'date',
  MessageType.state: 'state',
};
