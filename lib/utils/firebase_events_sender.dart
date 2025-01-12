import 'package:firebase_analytics/firebase_analytics.dart';

/// 광고를 보거나 클릭했을 때 이벤트 보내기용
void sendFirebaseEventForAds({required String eventName, String eventKey = "clickCount", int? clickCount}) {
  FirebaseAnalytics.instance.logEvent(
    name: eventName,
    parameters: {
      eventKey: clickCount.toString()
    },
  );
}
