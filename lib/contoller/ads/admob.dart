import 'dart:io';

class AdManager{

  String bannerAdUnitId(String androidBanner, String iosBanner) {
    if (Platform.isAndroid) {
      return androidBanner;
    } else if (Platform.isIOS) {
      return iosBanner;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String interstitialAdUnitId(String androidInterstitial, String iosInterstitial) {
    if (Platform.isAndroid) {
      return androidInterstitial;
    } else if (Platform.isIOS) {
      return iosInterstitial;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String rewardedAdUnitId(String androidReward, String iosReward) {
    if (Platform.isAndroid) {
      return androidReward;
    } else if (Platform.isIOS) {
      return iosReward;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}