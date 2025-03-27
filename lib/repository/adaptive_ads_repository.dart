import 'package:shared_preferences/shared_preferences.dart';

class AdaptiveAdsRepository {
  // SharedPreferences 인스턴스를 저장할 변수
  SharedPreferences? _prefs;

  // SharedPreferences 초기화
  Future<SharedPreferences> _initPrefs() async {
    // 이미 초기화되어 있다면 캐시된 인스턴스 반환
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // 저장된 시간을 가져와서 현재 시간과 비교하여 2시간을 초과하면 true, 2시간 미만이거나 값이 없으면 false를 반환
  Future<bool> isOverAdaptiveAdsTime() async {
    final prefs = await _initPrefs();
    final savedTimeStr = prefs.getString('adaptive_time');

    if (savedTimeStr == null) {
      return true;
    }

    final savedTime = DateTime.parse(savedTimeStr);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(savedTime);

    return difference.inHours >= 2;
  }

  // 현재 시간을 저장
  Future<void> saveCurrentTime() async {
    final prefs = await _initPrefs();
    final currentTime = DateTime.now().toIso8601String();
    await prefs.setString('adaptive_time', currentTime);
  }

  Future<void> deleteAdaptiveAdsTime() async {
    final prefs = await _initPrefs();
    await prefs.remove('adaptive_time');
  }
}