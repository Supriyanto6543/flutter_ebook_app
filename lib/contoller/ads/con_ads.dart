import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/model/ads/model_ads.dart';

Future<List<ModelAds>> fetchAdsSetup() async{
  var response = await Dio().get(ApiConstant().baseUrl+ApiConstant().api+ApiConstant().ads, options: Options(
    followRedirects: false,
    validateStatus: (status){
      return status! < 500;
    },
  ));
  var pdfHead = response.data;
  List<ModelAds> adsFetch = [];
  for(Map<String, dynamic> ad in pdfHead){
    adsFetch.add(ModelAds(ads: ad['ads'], startAppLIveMode: ad['startapplivemode'], startAppAccountId: ad['startappaccountid'],
        androidAppId: ad['androidappid'], iosAppId: ad['iosappid'], admobReward: ad['admobreward'], banner: ad['banner'],
        interstitial: ad['interstitial'], unityLiveMode: ad['unitylivemode'], unityGameId: ad['unitygameid'],
        unityBanner: ad['unitybanner'], unityInterstitial: ad['unityinterstitial'], unityReward: ad['unityreward']));
  }
  return adsFetch;
}