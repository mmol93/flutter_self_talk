import 'package:shared_preferences/shared_preferences.dart';

class AdsViewmodel {
  // SharedPreferences 인스턴스를 저장할 변수
  SharedPreferences? _prefs;
  final _adsClickCountPrefKey = "adsClickCountPrefKey";

  // SharedPreferences 초기화 메서드
  Future<SharedPreferences> _initPrefs() async {
    // 이미 초기화되어 있다면 캐시된 인스턴스 반환
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // 지금까지 이 앱에서 클릭된 광고 횟수
  Future<int?> getAdsClickCount() async {
    final prefs = await _initPrefs();
    final clickCount = prefs.getInt(_adsClickCountPrefKey);
    return clickCount;
  }

  // 지금까지 이 앱에서 클릭된 광고 횟수 갱신
  Future<void> setAdsClickCount() async {
    final prefs = await _initPrefs();
    var clickCount = prefs.getInt(_adsClickCountPrefKey);

    if (clickCount == 0 || clickCount == null) {
      prefs.setInt(_adsClickCountPrefKey, 1);
    } else {
      prefs.setInt(_adsClickCountPrefKey, clickCount++);
    }
  }
}
