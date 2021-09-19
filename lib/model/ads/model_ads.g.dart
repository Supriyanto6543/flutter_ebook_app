// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_ads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelAds _$ModelAdsFromJson(Map<String, dynamic> json) {
  return ModelAds(
    ads: json['ads'] as String,
    startAppLIveMode: json['startAppLIveMode'] as String,
    startAppAccountId: json['startAppAccountId'] as String,
    androidAppId: json['androidAppId'] as String,
    iosAppId: json['iosAppId'] as String,
    admobReward: json['admobReward'] as String,
    banner: json['banner'] as String,
    interstitial: json['interstitial'] as String,
    unityLiveMode: json['unityLiveMode'] as String,
    unityGameId: json['unityGameId'] as String,
    unityBanner: json['unityBanner'] as String,
    unityInterstitial: json['unityInterstitial'] as String,
    unityReward: json['unityReward'] as String,
  );
}

Map<String, dynamic> _$ModelAdsToJson(ModelAds instance) => <String, dynamic>{
      'ads': instance.ads,
      'startAppLIveMode': instance.startAppLIveMode,
      'startAppAccountId': instance.startAppAccountId,
      'androidAppId': instance.androidAppId,
      'iosAppId': instance.iosAppId,
      'admobReward': instance.admobReward,
      'banner': instance.banner,
      'interstitial': instance.interstitial,
      'unityLiveMode': instance.unityLiveMode,
      'unityGameId': instance.unityGameId,
      'unityBanner': instance.unityBanner,
      'unityInterstitial': instance.unityInterstitial,
      'unityReward': instance.unityReward,
    };
