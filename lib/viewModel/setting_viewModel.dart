import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/repository/password_repository.dart';
import 'package:self_talk/repository/setting_repository.dart';

final settingViewModelProvider = StateNotifierProvider.autoDispose<SettingViewmodel, SettingColor?>(
    (ref) => SettingViewmodel(SettingRepository(), PasswordRepository()));

class SettingViewmodel extends StateNotifier<SettingColor?> {
  final SettingRepository _settingRepository;
  final PasswordRepository _passwordRepository;
  bool? isPasswordSet;

  SettingViewmodel(this._settingRepository, this._passwordRepository) : super(null) {
    initSetting();
  }

  Future<void> updatePasswordStatus() async {
    isPasswordSet = await _passwordRepository.isPasswordSet();
  }

  Future<void> initSetting() async {
    Color backgroundColor = Color(await _settingRepository.getBackgroundColorCodePref());
    Color myMessageColor = Color(await _settingRepository.getMyMessageColorCodePref());
    Color othersMessageColor = Color(await _settingRepository.getOthersMessageColorCodePref());
    isPasswordSet = await _passwordRepository.isPasswordSet();

    state = SettingColor(
      backgroundColor: backgroundColor,
      myMessageColor: myMessageColor,
      othersMessageColor: othersMessageColor,
    );
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
    _settingRepository.updateOthersColorCodePref(color.value).then((value) => getSettingColors());
  }
}
