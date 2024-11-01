import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/models/list_item_model.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:self_talk/viewModel/friend_viewModel.dart';
import 'package:self_talk/widgets/chat/announce_icon.dart';
import 'package:self_talk/widgets/chat/dialog/chat_invite_friends_dialog.dart';
import 'package:self_talk/widgets/chat/dialog/modify_message_dialog.dart';
import 'package:self_talk/widgets/chat/merged_message.dart';
import 'package:self_talk/widgets/common/utils.dart';
import 'package:self_talk/widgets/dialog/common_time_picker_dialog.dart';
import 'package:self_talk/widgets/dialog/list_dialog.dart';

import '../../widgets/dialog/number_modify_dialog.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? chatId;

  const ChatScreen({this.chatId, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final String? currentChatRoomId;
  Friend? currentSelectedFriend;
  Friend? me;
  final _messageInputProvider = StateProvider<String>((ref) => '');
  final _inputTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 현재 채팅중인 사람이 직전 사람과 다름 = true
  Friend? previousSelectedFriend;

  @override
  void initState() {
    super.initState();
    currentChatRoomId = widget.chatId;
    currentSelectedFriend = null;
  }

  @override
  void dispose() {
    // 사용하던 observer, controller 해제
    _scrollController.dispose();
    _inputTextController.dispose();
    super.dispose();
  }

  /// 사진 파일에 대한 권한 요구하기
  Future<bool> _getPhotoPermission() async {
    var storageStatus = await Permission.storage.status;
    var photosStatus = await Permission.photos.status;

    // storage 권한 요청
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    // photos 권한 요청
    if (!photosStatus.isGranted) {
      photosStatus = await Permission.photos.request();
    }

    // 권한이 부여되었는지 여부를 반환
    return storageStatus.isGranted || photosStatus.isGranted;
  }

  Future<File?> _pickImage() async {
    bool isPermissionGranted = await _getPhotoPermission();

    if (isPermissionGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path); // 선택된 이미지 파일 반환
      } else {
        return null; // 이미지 선택 안 된 경우 null 반환
      }
    } else {
      showToast("이미지 파일을 첨부하기 위해선 권한이 필요합니다.");
    }
    return null;
  }

  /// 메시지 클릭 시 나오는 옵션 및 기능을 dialog로 표시
  void _showMessageOptions(ChatViewModel viewModel, Chat currentTargetChatData, int index) {
    final Message message = currentTargetChatData.messageList![index];

    showListDialog(
      title: message.imagePath == null ? message.message : "[사진]",
      context: context,
      listItemModel: [
        ListItemModel(
          itemTitle: "날짜 바꾸기",
          clickEvent: () async {
            final DateTime? pickedTime = await _showTimePickerDialog(
              viewModel: viewModel,
              message: message,
              isDatePicker: MessageType.message != message.messageType,
            );

            if (pickedTime != null) {
              viewModel.updateMessage(
                  chatId: currentChatRoomId!,
                  messageIndex: index,
                  message: message.copyWith(messageTime: pickedTime));
            }
          },
        ),
        ListItemModel(
          itemTitle: "수정하기",
          clickEvent: () => _showModifyMessageDialog(viewModel, message, index),
        ),
        ListItemModel(
          itemTitle: "삭제하기",
          clickEvent: () => viewModel.deleteMessage(
            chatId: currentChatRoomId!,
            messageIndex: index,
            message: message,
          ),
        ),
        ListItemModel(
          itemTitle: "읽은 않은 사람 수 바꾸기",
          clickEvent: () => _showNoWatchMemberNumber(viewModel, message, index),
        ),
        ListItemModel(
          itemTitle: "공지로 추가하기",
          clickEvent: () {
            viewModel.updateChatNoti(
              chatId: currentChatRoomId!,
              chatNoti: currentTargetChatData.createChatRoomNoti(
                message.message,
                currentTargetChatData.getFriendName(message.friendId) ?? "알 수 없음",
              ),
            );
          },
        )
      ],
    );
  }

  /// 메시지에서 추가 기능 사용 옵션 Dialog 보여주기
  void _showAttachmentOptions(
      {required ChatViewModel viewModel, required Friend me, required Chat currentTargetChatData}) {
    showListDialog(
      title: "추가 기능",
      context: context,
      listItemModel: [
        ListItemModel(
          itemTitle: "사진 파일 첨부",
          clickEvent: () async {
            final File? pickedImage = await _pickImage();

            if (pickedImage != null) {
              // TODO: 채팅방 마지막 메시지 업데이트 하기("사진을 보냈습니다.")
              _sendMessage(
                imagePath: pickedImage.path,
                viewModel: viewModel,
                me: me,
                currentMemberNumber: currentTargetChatData.chatMembers.length,
              );
            }
          },
        ),
        ListItemModel(
          itemTitle: "날짜 구분선 추가하기",
          clickEvent: () async {
            final DateTime? pickedTime =
                await _showTimePickerDialog(viewModel: viewModel, isDatePicker: true);
            if (pickedTime != null) {
              _sendMessage(
                  viewModel: viewModel,
                  me: me,
                  currentMemberNumber: currentTargetChatData.chatMembers.length,
                  messageType: MessageType.date,
                  pickedDate: pickedTime);
            }
          },
        ),
      ],
    );
  }

  /// 채팅을 시작할 친구 선택
  void _showFriendSelectionDialog(Friend me, Chat targetChatData) {
    showListDialog(context: context, listItemModel: [
      for (var friend in targetChatData.chatMembers)
        ListItemModel(
          itemTitle: friend.name == me.name ? "(자신)${friend.name}" : friend.name,
          clickEvent: () {
            setState(() {
              currentSelectedFriend = friend;
            });
          },
        )
    ]);
  }

  /// 채팅방의 햄버거 버튼 눌렀을 때 Dialog 띄우기
  void _showChatRoomOptionDialog({
    required ChatViewModel viewModel,
    required Chat targetChatData,
    required FriendViewModel friendViewModel,
    required List<Friend> wholeFriendList,
  }) {
    // TODO: 넣지 않은 기능들 추가하기
    showListDialog(
      title: "채팅방 설정 변경",
      context: context,
      listItemModel: [
        ListItemModel(
            itemTitle: "친구 초대하기",
            clickEvent: () {
              _inviteNewFriend(
                viewModel: viewModel,
                currentTargetChatData: targetChatData,
                friendViewModel: friendViewModel,
                wholeFriendList: wholeFriendList,
              );
            }),
        ListItemModel(
          itemTitle: "친구 강퇴하기",
          clickEvent: () {
            _leaveFriend(
              viewModel: viewModel,
              currentTargetChatData: targetChatData,
            );
          }
        ),
        ListItemModel(
          itemTitle: "채팅방 이름 변경",
        ),
        ListItemModel(
          itemTitle: "배경색 변경",
        ),
        ListItemModel(
          itemTitle: "갭쳐용으로 전환하기",
        ),
      ],
    );
  }

  /// TimePicker로 메시지의 시간 바꾸기
  Future<DateTime?> _showTimePickerDialog({
    required ChatViewModel viewModel,
    Message? message,
    bool isDatePicker = false,
  }) async {
    if (isDatePicker) {
      // 날짜 선택기
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: message?.messageTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      return pickedDate;
    } else {
      // 시간 선택기
      final DateTime? pickedTime = await showMyTimePickerDialog(
        context,
        initTime: TimeOfDay.fromDateTime(message?.messageTime ?? DateTime.now()),
      );
      // 시간을 `DateTime` 형식으로 변환하여 반환
      if (pickedTime != null) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      }
    }
    return null;
  }

  /// 읽은 사람 수 바꾸기 Dialog 표시
  Future<void> _showNoWatchMemberNumber(
    ChatViewModel viewModel,
    Message message,
    int index,
  ) async {
    final int? enteredNumber = await showNumericInputDialog(context);

    if (enteredNumber != null) {
      viewModel.updateMessage(
          chatId: currentChatRoomId!,
          messageIndex: index,
          message: message.copyWith(notSeenMemberNumber: enteredNumber));
    }
  }

  /// 메시지 수정 Dialog 표시
  void _showModifyMessageDialog(
    ChatViewModel viewModel,
    Message message,
    int index,
  ) {
    showModifyMessageDialog(
      message: message,
      viewModel: viewModel,
      context: context,
      clickEvent: (message) {
        _updateMessage(viewModel, message, index);
      },
    );
  }

  /// DB의 Message 데이터 업데이트
  void _updateMessage(
    ChatViewModel viewModel,
    Message message,
    int index,
  ) {
    viewModel.updateMessage(
      chatId: currentChatRoomId!,
      messageIndex: index,
      message: Message(
        friendId: message.friendId,
        messageTime: message.messageTime,
        message: message.message,
        secondMessage: message.secondMessage,
        messageType: message.messageType,
        isMe: message.isMe,
        notSeenMemberNumber: message.notSeenMemberNumber,
      ),
    );
  }

  /// 신규 채팅 메시지를 보낸다.
  void _sendMessage({
    String? message,
    String? secondMessage,
    String? imagePath,
    MessageType messageType = MessageType.message,
    DateTime? pickedDate,
    required ChatViewModel viewModel,
    required Friend me,
    required int currentMemberNumber,
  }) {
    if (messageType != MessageType.message && currentSelectedFriend == null) {
      currentSelectedFriend = me;
    }
    if (currentSelectedFriend != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ListView에 reverse를 적용했으니 0.0으로 가게 해야 제일 밑으로 간다.
        _scrollController.jumpTo(0.0);
      });

      viewModel.addMessage(
          chatId: currentChatRoomId!,
          message: Message(
              friendId: currentSelectedFriend!.id,
              messageTime: pickedDate ?? DateTime.now(),
              message: message ?? "",
              secondMessage: secondMessage,
              messageType: messageType,
              isMe: me.name == currentSelectedFriend!.name ? true : false,
              notSeenMemberNumber: currentMemberNumber - 1,
              imagePath: imagePath),
          notSameSpeaker:
              currentSelectedFriend != previousSelectedFriend || previousSelectedFriend == null);

      previousSelectedFriend = currentSelectedFriend;
    } else {
      showToast("먼저 메시지를 보낼 친구를 선택하세요");
    }
  }

  /// 새로운 멤버를 채팅방에 초대한다.
  void _inviteNewFriend({
    required ChatViewModel viewModel,
    required Chat currentTargetChatData,
    required FriendViewModel friendViewModel,
    required List<Friend> wholeFriendList,
  }) async {
    // TODO: 나간 이후 해당 채팅방의 마지막 메시지는 바뀌지 않게 하기
    if (currentSelectedFriend == null) {
      showToast("\"현재 채팅 유저\"를 먼저 선택해야 합니다.");
    } else {
      // 현재 채팅방에 초대되어있지 않은 멤버들
      final notIncludedMemberList = wholeFriendList
          .where(
            (wholeFriend) =>
                !currentTargetChatData.chatMembers.any((member) => wholeFriend.id == member.id),
          )
          .toList();
      if (notIncludedMemberList.isEmpty) {
        showToast("초대할 수 있는 친구가 없습니다.\n새로운 친구를 생성하세요.");
      } else {
        showInviteFriendsDialog(
            notInvitedFriendList: notIncludedMemberList,
            context: context,
            clickEvent: (invitedFriendList) {
              setState(() {
                String invitedFriendText = invitedFriendList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String friendName = "<u>${entry.value.name}</u>";

                  if (index == invitedFriendList.length - 1) "님과 $friendName";
                  return friendName;
                }).join(", ");

                final invitedFriendMessageText = currentSelectedFriend == me
                    ? "$invitedFriendText님을 초대했습니다."
                    : "${currentSelectedFriend!.name}님이 $invitedFriendText님을 초대했습니다.";

                viewModel.inviteNewMember(
                  chatId: currentChatRoomId!,
                  invitedFriendList: invitedFriendList,
                  inviteMessage: Message(
                    friendId: currentSelectedFriend!.id,
                    messageTime: DateTime.now(),
                    message: invitedFriendMessageText,
                    messageType: MessageType.state,
                    isMe: false,
                    notSeenMemberNumber: 0,
                  ),
                );
              });
            });
        showToast("현재 채팅 유저가 '초대하는 사람'이 됩니다.");
      }
    }
  }

  void _leaveFriend({
    required ChatViewModel viewModel,
    required Chat currentTargetChatData,
  }) {
    List<Friend> targetFriends = currentTargetChatData.chatMembers;

    // TODO: 나간 이후 해당 채팅방의 마지막 메시지는 바뀌지 않게 하기
    showListDialog(
        title: "이 방을 나갈 친구 선택",
        context: context,
        listItemModel: targetFriends
            .map((friend) => ListItemModel(
                  itemTitle: friend.name,
                  clickEvent: () {
                    setState(() {
                      viewModel.leaveFriend(
                        chatId: currentChatRoomId!,
                        leaveFriend: friend,
                        inviteMessage: Message(
                          friendId: friend.id,
                          messageTime: DateTime.now(),
                          message: "${friend.name}님이 나갔습니다.",
                          secondMessage: "채팅방으로 초대하기",
                          messageType: MessageType.state,
                          isMe: false,
                          notSeenMemberNumber: 0,
                        ),
                      );
                    });
                  },
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final friendViewModel = ref.watch(friendViewModelProvider.notifier);
    final wholeFriendList = ref.watch(friendViewModelProvider);
    final wholeChatList = ref.watch(chatViewModelProvider);
    final Chat targetChatData = wholeChatList!.chatRoom![currentChatRoomId]!;
    me = targetChatData.chatMembers.firstWhere((friend) => friend.me == 1);

    return Scaffold(
      backgroundColor: defaultBackground,
      appBar: AppBar(
        backgroundColor: defaultBackground,
        title: Row(
          children: [
            Text(
              targetChatData.title ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Text(
              targetChatData.chatMembers.length.toString(),
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          // TODO: 메뉴 버튼 기능(대화상대 초대, 캡처용으로 전환 등) 추가 필요
          IconButton(
              onPressed: () {
                _showChatRoomOptionDialog(
                  viewModel: viewModel,
                  targetChatData: targetChatData,
                  friendViewModel: friendViewModel,
                  wholeFriendList: wholeFriendList,
                );
              },
              icon: const Icon(Icons.menu)),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      // ListView에서 reverse를 true로 했기 때문에 사용하는 데이터도 reverse 처리를 해서 사용한다.
                      final reversedChatIndex =
                          (targetChatData.messageList?.length ?? 0) - index - 1;
                      return GestureDetector(
                          onTap: () {
                            _showMessageOptions(viewModel, targetChatData, reversedChatIndex);
                          },
                          child: getMergedMessage(
                              showDate: targetChatData.shouldShowDate(reversedChatIndex),
                              isMe: targetChatData.messageList![reversedChatIndex].isMe,
                              shouldUseTailBubble:
                                  targetChatData.shouldUseTailBubble(reversedChatIndex),
                              message: targetChatData.messageList![reversedChatIndex],
                              friendName: targetChatData.getFriendName(
                                      targetChatData.messageList![reversedChatIndex].friendId) ??
                                  "(알 수 없음)",
                              profilePicturePath: targetChatData.getaFriendProfilePath(),
                              messageType:
                                  targetChatData.messageList![reversedChatIndex].messageType,
                              pickedDate:
                                  targetChatData.messageList![reversedChatIndex].messageTime));
                    },
                    itemCount: targetChatData.messageList?.length ?? 0),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("현재 채팅 유저: "),
                      TextButton(
                        onPressed: () {
                          _showFriendSelectionDialog(me!, targetChatData);
                        },
                        child: Text(
                          currentSelectedFriend != null
                              ? me!.id == currentSelectedFriend?.id
                                  ? "(자신)${currentSelectedFriend!.name}"
                                  : currentSelectedFriend!.name
                              : "선택된 친구 없음",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Container(
                      color: Colors.white,
                      // IntrinsicHeight를 사용하면 Row 위젯의 자식의 height도 같이 커지게 할 수 있다.
                      child: IntrinsicHeight(
                        child: Row(
                          // IntrinsicHeight을 사용함과 동시에 CrossAxisAlignment.stretch도 적용해야한다.
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (me == null) {
                                  showToast("\"현재 채팅 유저\"를 먼저 선택해야 합니다.");
                                } else {
                                  _showAttachmentOptions(
                                      viewModel: viewModel,
                                      me: me!,
                                      currentTargetChatData: targetChatData);
                                }
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _inputTextController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  ref.read(_messageInputProvider.notifier).state = text;
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/kid.png',
                                width: 34,
                                height: 34,
                                color: Colors.grey,
                              ),
                            ),
                            Consumer(builder: (context, ref, child) {
                              var messageText = ref.watch(_messageInputProvider);
                              if (messageText.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(13),
                                  child: SvgPicture.asset(
                                    'assets/images/sharp.svg',
                                    width: 20,
                                    colorFilter:
                                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    _sendMessage(
                                        viewModel: viewModel,
                                        message: messageText,
                                        me: me!,
                                        currentMemberNumber: targetChatData.chatMembers.length);
                                    // 보낸 후 TextInput 초기화
                                    ref.read(_messageInputProvider.notifier).state = "";
                                    _inputTextController.text = "";
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(13),
                                    alignment: Alignment.bottomCenter,
                                    decoration: const BoxDecoration(color: defaultYellow),
                                    child: const Icon(size: 20, Icons.send, color: Colors.black),
                                  ),
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// 공지 부분
          if (targetChatData.notification?.isMinimize == true)

            /// Announce를 완전히 접었을 때
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  viewModel.updateChatNoti(
                    chatId: currentChatRoomId!,
                    chatNoti: targetChatData.changeNotiMinimizeStatus(),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // 배경 색상
                    shape: BoxShape.circle, // 둥근 배경 모양
                  ),
                  child: getAnnounceIcon(),
                ),
              ),
            )
          else if (targetChatData.notification?.message != null)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max, // 최대 너비 사용
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: getAnnounceIcon(),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  targetChatData.notification!.message,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: targetChatData.notification!.folded ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Visibility(
                                  visible: !targetChatData.notification!.folded,
                                  child: Text(
                                    targetChatData.notification!.userName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              viewModel.updateChatNoti(
                                chatId: currentChatRoomId!,
                                chatNoti: targetChatData.changeNotiFoldStatus(),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                targetChatData.notification!.folded
                                    ? Icons.keyboard_arrow_down_outlined
                                    : Icons.keyboard_arrow_up_outlined,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !targetChatData.notification!.folded,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    viewModel.updateChatNoti(
                                      chatId: currentChatRoomId!,
                                      chatNoti: null,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text(
                                    "다시 열지 않음",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    viewModel.updateChatNoti(
                                      chatId: currentChatRoomId!,
                                      chatNoti: targetChatData.changeNotiMinimizeStatus(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8))),
                                  child: const Text(
                                    "접어두기",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
