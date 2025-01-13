import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/repository/adaptive_ads_repository.dart';
import 'package:self_talk/repository/password_repository.dart';
import 'package:self_talk/repository/setting_repository.dart';

final settingViewModelProvider =
    StateNotifierProvider.autoDispose<SettingViewmodel, AsyncValue<SettingColor?>>((ref) =>
        SettingViewmodel(SettingRepository(), PasswordRepository(), AdaptiveAdsRepository()));

class SettingViewmodel extends StateNotifier<AsyncValue<SettingColor?>> {
  final SettingRepository _settingRepository;
  final PasswordRepository _passwordRepository;
  final AdaptiveAdsRepository _adaptiveAdsRepository;
  bool? isPasswordSet;
  String? appVersion;

  SettingViewmodel(this._settingRepository, this._passwordRepository, this._adaptiveAdsRepository)
      : super(const AsyncValue.loading()) {
    initSetting();
  }

  Future<void> updateAdaptiveAdsTime() async {
    _adaptiveAdsRepository.saveCurrentTime();
  }

  Future<void> deleteAdaptiveAdsTime() async {
    _adaptiveAdsRepository.deleteAdaptiveAdsTime();
  }

  Future<void> updatePasswordStatus() async {
    isPasswordSet = await _passwordRepository.isPasswordSet();
  }

  Future<void> initSetting() async {
    try {
      state = const AsyncValue.loading();

      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      Color backgroundColor = Color(await _settingRepository.getBackgroundColorCodePref());
      Color myMessageColor = Color(await _settingRepository.getMyMessageColorCodePref());
      Color othersMessageColor = Color(await _settingRepository.getOthersMessageColorCodePref());
      isPasswordSet = await _passwordRepository.isPasswordSet();

      state = AsyncValue.data(SettingColor(
        backgroundColor: backgroundColor,
        myMessageColor: myMessageColor,
        othersMessageColor: othersMessageColor,
      ));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> getSettingColors() async {
    Color backgroundColor = Color(await _settingRepository.getBackgroundColorCodePref());
    Color myMessageColor = Color(await _settingRepository.getMyMessageColorCodePref());
    Color othersMessageColor = Color(await _settingRepository.getOthersMessageColorCodePref());
    state = AsyncValue.data(SettingColor(
      backgroundColor: backgroundColor,
      myMessageColor: myMessageColor,
      othersMessageColor: othersMessageColor,
    ));
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
