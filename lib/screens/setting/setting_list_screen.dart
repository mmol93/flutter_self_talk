import 'package:flutter/material.dart';
import 'package:self_talk/models/setting.dart';
import 'package:self_talk/widgets/setting/item_setting.dart';

class SettingListScreen extends StatelessWidget {
  SettingListScreen({super.key});

  // 설정 화면에 들어갈 리스트 아이템들
  final List<Setting> settingItemList = [
    // TODO: 각각 항목에 대한 클릭 이벤트 및 표시 기능 추가하기
    Setting(mainTitle: "채팅방 배경색 변경", clickEvent: () {}, colorCode: "59636c"),
    Setting(mainTitle: "채팅방 자신의 말풍선 색 변경", clickEvent: () {}, colorCode: "ffeb34"),
    Setting(mainTitle: "채팅방 상대방 말풍선 색 변경", clickEvent: () {}, colorCode: "a5cec0"),
    Setting(
        mainTitle: "암호 잠금 설정하기",
        subTitle: "암호를 분실했을 때는 0 왼쪽의 빈 공간을 길게 누르세요",
        isCheckbox: false,
        clickEvent: () {}),
    Setting(mainTitle: "버전", statusText: "1.0.0"),
    Setting(mainTitle: "라이센스", clickEvent: () {}),
    Setting(mainTitle: "개인정보 보호정책", clickEvent: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ItemSetting(
          mainTitle: settingItemList[index].mainTitle,
          subTitle: settingItemList[index].subTitle,
          clickEvent: settingItemList[index].clickEvent,
          statusText: settingItemList[index].statusText,
          isCheckbox: settingItemList[index].isCheckbox,
          colorCode: settingItemList[index].colorCode,
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.5),
        thickness: 0.5,
      ),
      itemCount: settingItemList.length,
    );
  }
}
