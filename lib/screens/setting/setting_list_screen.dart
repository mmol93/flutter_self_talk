import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/setting.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/screens/setting/license_screen.dart';
import 'package:self_talk/screens/setting/passwrod_pad_screen.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/viewModel/setting_viewModel.dart';
import 'package:self_talk/widgets/ads/google_reward_ads.dart';
import 'package:self_talk/widgets/common/utils.dart';
import 'package:self_talk/widgets/dialog/color_picker_dialog.dart';
import 'package:self_talk/widgets/dialog/simple_dialog.dart';
import 'package:self_talk/widgets/setting/item_setting.dart';

import '../../navigator/moving_navigator.dart';

class SettingListScreen extends ConsumerStatefulWidget {
  const SettingListScreen({super.key});

  @override
  ConsumerState<SettingListScreen> createState() => _SettingListScreenState();
}

class _SettingListScreenState extends ConsumerState<SettingListScreen> {
  late SettingViewmodel _settingViewModel;
  var loadingCount = 0;

  // 설정 화면에 들어갈 리스트 아이템들
  List<Setting> settingItemList = [];

  List<Setting> createSettingList(SettingColor settingColor) {
    return [
      Setting(
        mainTitle: "채팅방 배경색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context, initColor: settingColor.backgroundColor, type: backgroundColorKey);
          if (pickedColor != null) {
            _settingViewModel.setBackgroundColor(pickedColor);
          }
        },
        color: settingColor.backgroundColor,
      ),
      Setting(
        mainTitle: "채팅방 자신의 말풍선 색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context, initColor: settingColor.myMessageColor, type: myMessageColorKey);
          if (pickedColor != null) {
            _settingViewModel.setMyMessageColor(pickedColor);
          }
        },
        color: settingColor.myMessageColor,
      ),
      Setting(
        mainTitle: "채팅방 상대방 말풍선 색 변경",
        clickEvent: () async {
          Color? pickedColor = await showColorPicker(
              context: context,
              initColor: settingColor.othersMessageColor,
              type: othersMessageColorKey);
          if (pickedColor != null) {
            _settingViewModel.setOthersMessageColor(pickedColor);
          }
        },
        color: settingColor.othersMessageColor,
      ),
      Setting(
        mainTitle: "암호 잠금 설정하기",
        subTitle: "암호를 분실했을 때는 0 오른쪽의 빈 공간을 길게 누르세요",
        isCheckbox: _settingViewModel.isPasswordSet,
        clickEvent: () async {
          if (_settingViewModel.isPasswordSet == true) {
            slideNavigateStateful(context, const PasswordInputScreen(isInit: true),
                backFunction: () {
              setState(() {
                _settingViewModel.updatePasswordStatus();
              });
            });
          } else {
            slideNavigateStateful(context, const PasswordInputScreen(isSetup: true),
                backFunction: () {
              setState(() {
                _settingViewModel.updatePasswordStatus();
              });
            });
          }
        },
      ),
      Setting(
        mainTitle: "광고 보고 2시간 광고 없애기",
        subTitle: "광고를 시청하시면 2시간 동안 모든 광고가 사라집니다.",
        longClickEvent: () {
          if (appFlavor == "dev") {
            _settingViewModel.deleteAdaptiveAdsTime();
            showToast("광고 시청 시간 기록 삭제");
          }
        },
        clickEvent: () {
          showTextDialog(
            context: context,
            title: "광고 시청",
            okText: "네",
            contentText: "광고를 시청하시면\n2시간 동안 모든 광고가 사라집니다.\n동의하십니까?",
            needNoButton: true,
            contentButtonPressed: () {
              slideNavigateStateful(context, RewardedAdWidget(
                onRewardEarned: (_) {
                  _settingViewModel.updateAdaptiveAdsTime();
                },
              ));
            },
          );
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    _settingViewModel = ref.watch(settingViewModelProvider.notifier);
    final settingColorState = ref.watch(settingViewModelProvider);

    return settingColorState.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stack) {
        return Center(
          child: Text("Error: $error"),
        );
      },
      data: (settingColor) {
        // settingColor가 null이 아닐 때만 리스트 생성
        if (settingColor != null && settingItemList.isEmpty) {
          settingItemList = createSettingList(settingColor);
        }

        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ItemSetting(
              mainTitle: settingItemList[index].mainTitle,
              subTitle: settingItemList[index].subTitle,
              clickEvent: settingItemList[index].clickEvent,
              longClickEvent: settingItemList[index].longClickEvent,
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
        );
      },
    );
  }
}
