import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/repository/setting_repository.dart';

final settingViewModelProvider = StateNotifierProvider.autoDispose<SettingViewmodel, SettingColor?>(
    (ref) => SettingViewmodel(SettingRepository()));

class SettingViewmodel extends StateNotifier<SettingColor?> {
  final SettingRepository _settingRepository;

  SettingViewmodel(this._settingRepository) : super(null) {
    getSettingColors();
  }

  Future<void> getSettingColors() async {
    Color backgroundColor = Color(await _settingRepository.getBackgroundColorCodePref());
    Color myMessageColor = Color(await _settingRepository.getMyMessageColorCodePref());
    Color othersMessageColor = Color(await _settingRepository.getOthersMessageColorCodePref());
    state = SettingColor(
      backgroundColor: backgroundColor,
      myMessageColor: myMessageColor,
      othersMessageColor: othersMessageColor,
    );
  }

  void setBackgroundColor(Color color) {
    _settingRepository
        .updateBackgroundColorCodePref(color.value)
        .then((value) => getSettingColors());
  }

  void setMyMessageColor(Color color) {
    _settingRepository
        .updateMyMessageColorCodePref(color.value)
        .then((value) => getSettingColors());
  }

  void setOthersMessageColor(Color color) {
    _settingRepository
        .updateOthersColorCodePref(color.value)
        .then((value) => getSettingColors());
  }
}
