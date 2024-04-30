import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/widgets/common/utils.dart';

class UpdateFriendScreen extends StatefulWidget {
  const UpdateFriendScreen(
      {super.key, required this.updateFriend, required this.targetFriend});

  final void Function(Friend friend) updateFriend;
  final Friend targetFriend;

  @override
  State<UpdateFriendScreen> createState() => _UpdateFriendScreenState();
}

class _UpdateFriendScreenState extends State<UpdateFriendScreen> {
  Friend? _targetFriend;
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  var _myProfileCheck = false; // '내 프로필'로 설정했는지
  var _isMyProfile = 0; // '내 프로필' 설정 유무를 Sqlite에 저장하기 위한 변수

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _targetFriend = Friend(
        id: _targetFriend!.id,
        name: _nameController.text,
        message: _messageController.text,
        profileImgPath: pickedImage.path,
      );
    });
  }

  void _updateProfile() {
    if (_nameController.text.trim().isNotEmpty) {
      if (_targetFriend?.profileImgPath.isNotEmpty == true) {
        // 그림 파일을 셋팅한 경우
        widget.updateFriend(
          Friend(
            id: _targetFriend!.id,
            name: _nameController.text,
            message: _messageController.text,
            profileImgPath: _targetFriend!.profileImgPath,
            me: _isMyProfile,
          ),
        );
      } else {
        widget.updateFriend(
          Friend(
            id: _targetFriend!.id,
            name: _nameController.text,
            message: _messageController.text,
            profileImgPath: Strings.defaultProfileImgPath,
            me: _isMyProfile,
          ),
        );
      }
      Navigator.pop(context);
    } else {
      showToast("이름을 지정 해야 합니다.");
    }
  }

  void _setMyProfile(bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        _myProfileCheck = true;
        _isMyProfile = 1;
      } else {
        _myProfileCheck = false;
        _isMyProfile = 0;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_targetFriend == null) {
      // 클릭한 친구 데이터로 값들을 초기화
      _targetFriend = widget.targetFriend;
      _nameController.text = _targetFriend!.name;
      _messageController.text = _targetFriend!.message;
      _myProfileCheck = _targetFriend!.me == 1;
      _isMyProfile = _targetFriend!.me;
    }
    const imageSize = 68.0;
    const buttonSize = 120.0;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: defaultAppbarColor,
          title: const Text("대화상대 추가"),
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: const Text(
                      "자신 또는 친구가 될 프로필을 생성하세요.",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (_targetFriend?.profileImgPath == null)
                    IconButton(
                      onPressed: () {
                        _pickImage();
                      },
                      icon: const Icon(
                        Icons.person,
                        size: imageSize,
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        minimumSize: MaterialStateProperty.all(
                            const Size(buttonSize, buttonSize)),
                        maximumSize: MaterialStateProperty.all(
                            const Size(buttonSize, buttonSize)),
                        backgroundColor:
                            MaterialStateProperty.all(defaultProfileBackground),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Image.file(
                        File(_targetFriend!.profileImgPath),
                        fit: BoxFit.cover,
                        width: buttonSize,
                        height: buttonSize,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return IconButton(
                            onPressed: null,
                            icon: const Icon(
                              Icons.person,
                              size: imageSize,
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(buttonSize, buttonSize)),
                              maximumSize: MaterialStateProperty.all(
                                  const Size(buttonSize, buttonSize)),
                              backgroundColor: MaterialStateProperty.all(
                                  defaultProfileBackground),
                            ),
                          );
                        },
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: "프로필 이름"),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: "프로필 메시지"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _myProfileCheck = !_myProfileCheck;
                      _setMyProfile(_myProfileCheck);
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _myProfileCheck,
                          onChanged: _setMyProfile,
                        ),
                        const Text("내 '프로필'로 설정하기 ")
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: FilledButton(
                      onPressed: () {
                        _updateProfile();
                      },
                      style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: defaultYellow),
                      child: const Text(
                        "수정하기",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
