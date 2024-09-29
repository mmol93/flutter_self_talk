
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/models/list_item_model.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';
import 'package:self_talk/widgets/chat/message_from_me.dart';
import 'package:self_talk/widgets/chat/message_from_others.dart';
import 'package:self_talk/widgets/common/utils.dart';
import 'package:self_talk/widgets/dialog/common_time_picker_dialog.dart';
import 'package:self_talk/widgets/dialog/list_dialog.dart';
import 'package:self_talk/widgets/dialog/modify_message_dialog.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? chatId;

  const ChatScreen({this.chatId, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final String? currentChatRoomId;
  Friend? currentSelectedFriend;
  final _messageInputProvider = StateProvider<String>((ref) => '');
  final _inputTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int reversedChatIndex = 0;
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

  /// 메시지 클릭 시 나오는 옵션 및 기능을 dialog로 표시
  void _showMessageOptions(
      ChatViewModel viewModel, Chat targetChatData, int index) {
    final Message message = targetChatData.messageList![index];

    showListDialog(
      title: message.message,
      context: context,
      listItemModel: [
        ListItemModel(
          itemTitle: "날짜 바꾸기",
          clickEvent: () => _showTimePickerDialog(viewModel, message, index),
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
      ],
    );
  }

  void _showFriendSelectionDialog(Friend me, Chat targetChatData) {
    showListDialog(context: context, listItemModel: [
      for (var friend in targetChatData.chatMember)
        ListItemModel(
          itemTitle: friend.name == me.name ? "(자신)${friend.name}" : friend.name,
          clickEvent: () {
            currentSelectedFriend = friend;
            setState(() {});
          },
        )
    ]);
  }

  /// TimePicker로 메시지의 시간 바꾸기
  Future<void> _showTimePickerDialog(
    ChatViewModel viewModel,
    Message message,
    int index,
  ) async {
    final DateTime? pickedTime = await showMyTimePickerDialog(context,
        initTime: TimeOfDay.fromDateTime(message.messageTime));

    if (pickedTime != null) {
      viewModel.updateMessage(
          chatId: currentChatRoomId!,
          messageIndex: index,
          message: message.copyWith(messageTime: pickedTime));
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
        notSeenMemberNumber: message.notSeenMemberNumber
      ),
    );
  }

  void _sendMessage({
    required ChatViewModel viewModel,
    required String message,
    required Friend me,
    required int currentMemberNumber,
  }) {
    if (currentSelectedFriend != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ListView에 reverse를 적용했으니 0.0으로 가게 해야 제일 밑으로 간다.
        _scrollController.jumpTo(0.0);
      });

      viewModel.addMessage(
        chatId: currentChatRoomId!,
        message: Message(
          friendId: currentSelectedFriend!.id,
          messageTime: DateTime.now(),
          message: message,
          messageType: MessageType.message,
          isMe: me.name == currentSelectedFriend!.name ? true : false,
          notSeenMemberNumber: currentMemberNumber-1
        ),
        notSameSpeaker: currentSelectedFriend != previousSelectedFriend || previousSelectedFriend == null
      );

      previousSelectedFriend = currentSelectedFriend;
    } else {
      showToast("먼저 메시지를 보낼 친구를 선택하세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModelProvider.notifier);
    final wholeChatList = ref.watch(chatViewModelProvider);
    final Chat targetChatData = wholeChatList!.chatRoom![currentChatRoomId]!;
    final me = targetChatData.chatMember.firstWhere((friend) => friend.me == 1);

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
              targetChatData.chatMember.length.toString(),
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          // TODO: 메뉴 버튼 기능(대화상대 초대, 캡처용으로 전환 등) 추가 필요
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
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
                    reversedChatIndex = (targetChatData.messageList?.length ?? 0)- index - 1;
                    return GestureDetector(
                      onTap: () {_showMessageOptions(viewModel, targetChatData, reversedChatIndex);},
                      child: targetChatData.messageList![reversedChatIndex].isMe
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 4, 0),
                              child: MessageFromMe(
                                shouldUseTailBubble: targetChatData.shouldUseTailBubble(reversedChatIndex),
                                showDate: targetChatData.shouldShowDate(reversedChatIndex),
                                date: targetChatData.messageList![reversedChatIndex].messageTime,
                                message: targetChatData.messageList![reversedChatIndex].message,
                                notSeenMemberNumber: targetChatData.messageList![reversedChatIndex].notSeenMemberNumber,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(4, 5, 0, 0),
                              child: MessageFromOthers(
                                shouldUseTailBubble: targetChatData.shouldUseTailBubble(reversedChatIndex),
                                showDate: targetChatData.shouldShowDate(reversedChatIndex),
                                date: targetChatData.messageList![reversedChatIndex].messageTime,
                                message: targetChatData.messageList![reversedChatIndex].message,
                                friendName: targetChatData.getFriendName(targetChatData.messageList![reversedChatIndex].friendId) ?? "(알 수 없음)",
                                notSeenMemberNumber: targetChatData.messageList![reversedChatIndex].notSeenMemberNumber,
                              ),
                            ),
                    );
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
                        _showFriendSelectionDialog(me, targetChatData);
                      },
                      child: Text(currentSelectedFriend != null ? me == currentSelectedFriend ? "(자신)${currentSelectedFriend!.name}" : currentSelectedFriend!.name : "선택된 친구 없음",
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
                            // TODO: 미디어 파일 업로드 기능 필요
                            onPressed: () {},
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
                                ref.read(_messageInputProvider.notifier).state =
                                    text;
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
                                  colorFilter: const ColorFilter.mode(
                                      Colors.grey, BlendMode.srcIn),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  _sendMessage(
                                      viewModel: viewModel,
                                      message: messageText,
                                      me: me,
                                      currentMemberNumber: targetChatData.chatMember.length
                                  );
                                  // 보낸 후 TextInput 초기화
                                  ref.read(_messageInputProvider.notifier).state = "";
                                  _inputTextController.text = "";
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(13),
                                  alignment: Alignment.bottomCenter,
                                  decoration:
                                  const BoxDecoration(color: defaultYellow),
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
      ),
    );
  }
}
