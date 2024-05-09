// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      id: json['id'] as String,
      name: json['name'] as String,
      message: json['message'] as String? ?? "",
      profileImgPath:
          json['profileImgPath'] as String? ?? Strings.defaultProfileImgPath,
      me: (json['me'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'message': instance.message,
      'profileImgPath': instance.profileImgPath,
      'me': instance.me,
    };
