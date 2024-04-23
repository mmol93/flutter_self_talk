class Friend {
  final String id;
  final String name;
  String message;
  String profileImgPath;

  Friend({
    required this.id,
    required this.name,
    this.message = "",
    this.profileImgPath = "assets/images/profile_pic.png"
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'profileImgPath': profileImgPath,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      message: map['message'],
      profileImgPath: map['profileImgPath'],
    );
  }
}
