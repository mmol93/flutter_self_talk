import 'package:firebase_analytics/firebase_analytics.dart';

void sendFirebaseEventForAds({required String eventName}) {
  FirebaseAnalytics.instance.logEvent(
    name: eventName,
    parameters: {
      eventName: eventName
    },
  );
}
