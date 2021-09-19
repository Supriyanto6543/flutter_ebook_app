
import 'package:json_annotation/json_annotation.dart';
part 'model_ads.g.dart';

@JsonSerializable()
class ModelAds{

  String ads;
  String startAppLIveMode;
  String startAppAccountId;
  String androidAppId;
  String iosAppId;
  String admobReward;
  String banner;
  String interstitial;
  String unityLiveMode;
  String unityGameId;
  String unityBanner;
  String unityInterstitial;
  String unityReward;

  ModelAds({required this.ads, required this.startAppLIveMode, required this.startAppAccountId, required this.androidAppId,
    required this.iosAppId, required this.admobReward, required this.banner, required this.interstitial, required this.unityLiveMode,
    required this.unityGameId, required this.unityBanner, required this.unityInterstitial, required this.unityReward});

  factory ModelAds.fromJson (Map<String, dynamic> json) => _$ModelAdsFromJson(json);

  Map<String, dynamic> toJson() => _$ModelAdsToJson(this);
}