import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/friend.dart';
import 'package:uuid/uuid.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key, required this.friend});

  final void Function(Friend friend) friend;

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  Friend? _createdFriend;
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final _uuid = const Uuid();

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
      _createdFriend = Friend(
        id: _uuid.v4(),
        name: _nameController.text,
        message: _messageController.text,
        profileImgPath: pickedImage.path,
      );
    });
  }

  void _makeProfile() {
    if (_nameController.text.trim().isNotEmpty) {
      if (_createdFriend?.profileImgPath.isNotEmpty == true) {
        // 그림 파일을 셋팅한 경우
        widget.friend(
          Friend(
              id: _uuid.v4(),
              name: _nameController.text,
              message: _messageController.text,
              profileImgPath: _createdFriend!.profileImgPath),
        );
      } else {
        widget.friend(
          Friend(
              id: _uuid.v4(),
              name: _nameController.text,
              message: _messageController.text,
              profileImgPath: Strings.defaultProfileImgPath),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (_createdFriend?.profileImgPath == null)
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
                        File(_createdFriend!.profileImgPath),
                        fit: BoxFit.cover,
                        width: buttonSize,
                        height: buttonSize,
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
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: FilledButton(
                      onPressed: () {
                        _makeProfile();
                      },
                      style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: defaultYellow),
                      child: const Text(
                        "추가하기",
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
