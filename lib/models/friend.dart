import 'package:json_annotation/json_annotation.dart';
import 'package:self_talk/assets/strings.dart';
part 'friend.g.dart';

@JsonSerializable()
class Friend {
  final String id;
  final String name;
  String message;
  String profileImgPath;
  int me;

  Friend({
    required this.id,
    required this.name,
    this.message = "",
    this.profileImgPath = Strings.defaultProfileImgPath,
    this.me = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'profileImgPath': profileImgPath,
      'me': me
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      message: map['message'],
      profileImgPath: map['profileImgPath'],
      me: map['me']
    );
  }
  @override
  String toString() {
    return "Friend(id: $id, name: $name, message: $message, profileImgPath: $profileImgPath, me: $me)";
  }

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
