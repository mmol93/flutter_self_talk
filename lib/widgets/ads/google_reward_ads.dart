import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/utils/MyLogger.dart';
import 'package:self_talk/utils/firebase_events_sender.dart';
import 'package:self_talk/widgets/common/utils.dart';

const String androidTestAdaptiveAdsKey = "ca-app-pub-3940256099942544/5224354917";
const String iosTestAdaptiveAdsKey = "ca-app-pub-3940256099942544/1712485313";
final String? adsKey = dotenv.env['addmob_reward_app_id'];

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

class RewardedAdWidget extends StatefulWidget {
  final void Function(int rewardAmount)? onRewardEarned;

  const RewardedAdWidget({
    Key? key,
    this.onRewardEarned,
  }) : super(key: key);

  @override
  State<RewardedAdWidget> createState() => _RewardedAdWidgetState();
}

class _RewardedAdWidgetState extends State<RewardedAdWidget> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  int _retryCount = 0;

  final String adsId = _getAdsId() ?? "";

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    _retryCount++;
    RewardedAd.load(
      adUnitId: adsId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _setupFullScreenCallbacks();
          setState(() => _isAdLoaded = true);
          // 광고가 로드되면 자동으로 표시
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          setState(() => _isAdLoaded = false);
        },
      ),
    );
  }

  void _setupFullScreenCallbacks() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        MyLogger.info("보상형 광고: 시작");
      },
      onAdImpression: (ad) {
        MyLogger.info("보상형 광고: 로딩 성공");
        sendFirebaseEventForAds(eventName: Strings.eventNameWatchRewardsAds);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        MyLogger.info("보상형 광고: 실패 \n\n$error");
        ad.dispose();
        if (_retryCount == 2) {
          // 2번 실패하면 광고창 닫기
          // TODO: 인터넷 연결 끊은 상태에서 제대로 동작하는지 화인하기
          showToast("광고 로드에 실패했습니다.\n잠시후 다시 시도해주세요.");
          Navigator.pop(context);
        } else {
          _loadRewardedAd();
        }
        sendFirebaseEventForAds(eventName: Strings.eventNameLoadErrorRewardsAds);
      },
      onAdDismissedFullScreenContent: (ad) {
        MyLogger.info("보상형 광고: 종료");
        ad.dispose();

        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      onAdClicked: (ad) {
        MyLogger.info("보상형 광고: 클릭됨");
        sendFirebaseEventForAds(eventName: Strings.eventNameClickRewardsAds);
      },
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null || !_isAdLoaded) {
      debugPrint('Warning: Attempted to show ad before loading.');
      return;
    }

    _rewardedAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        MyLogger.info("보상형 광고: 시청 성공");
        sendFirebaseEventForAds(eventName: Strings.eventNameCompleteRewardsAds);
        widget.onRewardEarned?.call(reward.amount.toInt());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 버튼 대신 빈 컨테이너 반환
    return Container();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
