import 'package:shared_preferences/shared_preferences.dart';

class PasswordRepository {
  // SharedPreferences 인스턴스를 저장할 변수
  SharedPreferences? _prefs;

  // SharedPreferences 초기화 메서드
  Future<SharedPreferences> _initPrefs() async {
    // 이미 초기화되어 있다면 캐시된 인스턴스 반환
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 비밀번호 셋팅
  Future<void> setPassword(String password) async {
    final prefs = await _initPrefs();
    await prefs.setString('password', password);
  }

  Future<String> getPassword() async {
    final prefs = await _initPrefs();
    return prefs.getString('password') ?? "";
  }

  /// 비밀번호 사용 해제
  Future<void> initPassword() async {
    final prefs = await _initPrefs();
    await prefs.setString('password', "");
  }

  Future<bool> isPasswordSet() async {
    final prefs = await _initPrefs();
    if (prefs.getString("password") == null || prefs.getString("password") == "") {
      return false;
    } else {
      return true;
    }
  }
}
