import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  /// SharedPreferences 인스턴스를 저장할 변수
  SharedPreferences? _prefs;

  /// SharedPreferences 초기화 메서드
  Future<SharedPreferences> _initPrefs() async {
    // 이미 초기화되어 있다면 캐시된 인스턴스 반환
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 채팅방 배경색 초기화
  Future<void> _createBackgroundColorCodePref() async {
    final prefs = await _initPrefs();
    prefs.setInt(backgroundColorKey, defaultBackgroundColor.value);
  }

  /// 채팅방 배경색 업데이트
  Future<void> updateBackgroundColorCodePref(int colorCode) async {
    final prefs = await _initPrefs();
    if (prefs.getInt(backgroundColorKey) == null) {
      await _createBackgroundColorCodePref();
    } else {
      await prefs.setInt(backgroundColorKey, colorCode);
    }
  }

  /// 채팅방 배경색 가져오기
  Future<int> getBackgroundColorCodePref() async {
    final prefs = await _initPrefs();
    return prefs.getInt(backgroundColorKey) ?? defaultBackgroundColor.value;
  }

  /// 채팅방 내 채팅색 초기화
  Future<void> _createMyMessageColorCodePref() async {
    final prefs = await _initPrefs();
    prefs.setInt(myMessageColorKey, defaultMyMessageColor.value);
  }

  /// 채팅방 내 채팅색 업데이트
  Future<int> updateMyMessageColorCodePref(int colorCode) async {
    final prefs = await _initPrefs();
    if (prefs.getInt(myMessageColorKey) == null) {
      await _createMyMessageColorCodePref();
    } else {
      await prefs.setInt(myMessageColorKey, colorCode);
    }
    return prefs.getInt(myMessageColorKey)!;
  }

  /// 채팅방 내 채팅색 가져오기
  Future<int> getMyMessageColorCodePref() async {
    final prefs = await _initPrefs();
    return prefs.getInt(myMessageColorKey) ?? defaultMyMessageColor.value;
  }

  /// 채팅방 상대방 채팅색 초기화
  Future<void> _createOthersMessageColorCodePref() async {
    final prefs = await _initPrefs();
    prefs.setInt(othersMessageColorKey, defaultAppbarColor.value);
  }

  /// 채팅방 상대방 채팅색 업데이트
  Future<int> updateOthersColorCodePref(int colorCode) async {
    final prefs = await _initPrefs();
    if (prefs.getInt(othersMessageColorKey) == null) {
      await _createOthersMessageColorCodePref();
    } else {
      await prefs.setInt(othersMessageColorKey, colorCode);
    }
    return prefs.getInt(othersMessageColorKey)!;
  }

  /// 채팅방 상대방 채팅색 가져오기
  Future<int> getOthersMessageColorCodePref() async {
    final prefs = await _initPrefs();
    return prefs.getInt(othersMessageColorKey) ?? defaultOthersMessageColor.value;
  }
}