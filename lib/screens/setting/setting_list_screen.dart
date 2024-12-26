import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/models/setting.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/screens/setting/license_screen.dart';
import 'package:self_talk/screens/setting/passwrod_pad_screen.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/viewModel/setting_viewModel.dart';
import 'package:self_talk/widgets/dialog/color_picker_dialog.dart';
import 'package:self_talk/widgets/setting/item_setting.dart';

import '../../navigator/moving_navigator.dart';

class SettingListScreen extends ConsumerStatefulWidget {
  const SettingListScreen({super.key});

  @override
  ConsumerState<SettingListScreen> createState() => _SettingListScreenState();
}

class _SettingListScreenState extends ConsumerState<SettingListScreen> {
  late SettingViewmodel _settingViewModel;
  SettingColor? _settingColor;

  // 설정 화면에 들어갈 리스트 아이템들
  List<Setting> settingItemList = [];

  void updateSettingList() {
    settingItemList = [
      Setting(
        mainTitle: "채팅방 배경색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context,
              initColor: _settingColor?.backgroundColor ?? defaultBackgroundColor,
              type: backgroundColorKey);
          if (pickedColor != null) {
            _settingViewModel.setBackgroundColor(pickedColor);
          }
        },
        color: _settingColor?.backgroundColor ?? defaultBackgroundColor,
      ),
      Setting(
        mainTitle: "채팅방 자신의 말풍선 색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context,
              initColor: _settingColor?.myMessageColor ?? defaultMyMessageColor,
              type: myMessageColorKey);
          if (pickedColor != null) {
            _settingViewModel.setMyMessageColor(pickedColor);
          }
        },
        color: _settingColor?.myMessageColor ?? defaultMyMessageColor,
      ),
      Setting(
        mainTitle: "채팅방 상대방 말풍선 색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context,
              initColor: _settingColor?.othersMessageColor ?? defaultOthersMessageColor,
              type: othersMessageColorKey);
          if (pickedColor != null) {
            _settingViewModel.setOthersMessageColor(pickedColor);
          }
        },
        color: _settingColor?.othersMessageColor ?? defaultOthersMessageColor,
      ),
      Setting(
        mainTitle: "암호 잠금 설정하기",
        subTitle: "암호를 분실했을 때는 0 왼쪽의 빈 공간을 길게 누르세요",
        isCheckbox: _settingViewModel.isPasswordSet,
        clickEvent: () async {
          if (_settingViewModel.isPasswordSet == true) {
            // 비밀번호가 이미 설정되어 있는 상태일 때
            slideNavigateStateful(context, const PasswordInputScreen(isInit: true), backFunction: () {
              setState(() {
                _settingViewModel.updatePasswordStatus();
              });
            });
          } else {
            slideNavigateStateful(context, const PasswordInputScreen(isSetup: true), backFunction: () {
              setState(() {
                _settingViewModel.updatePasswordStatus();
              });
            });
          }
        },
      ),
      Setting(
        mainTitle: "버전",
        statusText: "1.0.0",
      ),
      Setting(
        mainTitle: "라이센스",
        clickEvent: () {
          slideNavigateStateful(context, const LicenseScreen());
        },
      ),
      // Setting(
      //   mainTitle: "개인정보 보호정책",
      //   clickEvent: () {},
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _settingViewModel = ref.watch(settingViewModelProvider.notifier);
    _settingColor = ref.watch(settingViewModelProvider);
    updateSettingList();

    return settingItemList.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ItemSetting(
                mainTitle: settingItemList[index].mainTitle,
                subTitle: settingItemList[index].subTitle,
                clickEvent: settingItemList[index].clickEvent,
                statusText: settingItemList[index].statusText,
                isCheckbox: settingItemList[index].isCheckbox,
                color: settingItemList[index].color,
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 0.5,
            ),
            itemCount: settingItemList.length,
          )
        : const Placeholder();
  }
}
