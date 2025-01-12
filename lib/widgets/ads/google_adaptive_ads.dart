import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:self_talk/utils/MyLogger.dart';
import 'package:self_talk/utils/firebase_events_sender.dart';

import '../../assets/strings.dart';

const String androidTestAdaptiveAdsKey = "ca-app-pub-3940256099942544/9214589741";
const String iosTestAdaptiveAdsKey = "ca-app-pub-3940256099942544/2435281174";
final String? adsKey = dotenv.env['addmob_adaptive_app_id'];

String? _getAdsId() {
  if (Platform.isAndroid) {
    if (appFlavor == "dev") {
      return androidTestAdaptiveAdsKey;
    } else {
      return adsKey;
    }
  } else if (Platform.isIOS) {
    if (appFlavor == "dev") {
      return iosTestAdaptiveAdsKey;
    } else {
      return adsKey;
    }
  } else {
    return null;
  }
}

/// This example demonstrates anchored adaptive banner ads.
class AnchoredAdaptiveAdsWidget extends StatefulWidget {
  const AnchoredAdaptiveAdsWidget({super.key});

  @override
  AnchoredAdaptiveWidget createState() => AnchoredAdaptiveWidget();
}

class AnchoredAdaptiveWidget extends State<AnchoredAdaptiveAdsWidget> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    final adsId = _getAdsId() ?? "";

    if (size == null) {
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: adsId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdClicked: (Ad ad) {
          sendFirebaseEventForAds(eventName: Strings.eventNameClickAdaptiveAds);
          MyLogger.info("적응형 광고 클릭됨");
        },
        onAdLoaded: (Ad ad) {
          sendFirebaseEventForAds(eventName: Strings.eventNameWatchAdaptiveAds);
          MyLogger.info("적응형 광고 실행됨");
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          sendFirebaseEventForAds(eventName: Strings.eventNameLoadErrorAdaptiveAds);
          MyLogger.info("적응형 광고 로딩 실패 \n\n$error");
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) => (_anchoredAdaptiveAd != null && _isLoaded)
      ? Container(
          color: Colors.green,
          width: _anchoredAdaptiveAd!.size.width.toDouble(),
          height: _anchoredAdaptiveAd!.size.height.toDouble(),
          child: AdWidget(ad: _anchoredAdaptiveAd!),
        )
      : Container();

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}
