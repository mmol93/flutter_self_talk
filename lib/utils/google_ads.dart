import 'package:flutter_dotenv/flutter_dotenv.dart';

const String androidTestAdsKey = "ca-app-pub-3940256099942544/9214589741";
const String iosTestAdsKey = "ca-app-pub-3940256099942544/2435281174";
final String? adsKey = dotenv.env['addmob_app_id'];
