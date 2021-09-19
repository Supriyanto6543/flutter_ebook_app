import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class AdManagerUnity {
  String gameId(String androidGameId, String iosGameId) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidGameId;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosGameId;
    }
    return '';
  }

  String bannerAdPlacementId(String androidBanner) {
    return androidBanner;
  }

  String interstitialVideoAdPlacementId(String androidInterstitial) {
    return androidInterstitial;
  }

  String rewardedVideoAdPlacementId(String androidReward) {
    return androidReward;
  }
}

class UnityInit {
  getInit(String androidGameId, String iosGameId, String testMode){
    UnityAds.init(
      gameId: AdManagerUnity().gameId(androidGameId, iosGameId),
      testMode: testMode == "0" ? true : false,
      listener: (state, args) => print('My Unity Shown: $state => $args'),
    );
  }
}