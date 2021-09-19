import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/ads/admob.dart';
import 'package:ebook_app/contoller/ads/con_ads.dart';
import 'package:ebook_app/contoller/ads/startapp.dart';
import 'package:ebook_app/contoller/ads/unity.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/contoller/con_detail.dart';
import 'package:ebook_app/contoller/con_save_favorite.dart';
import 'package:ebook_app/model/ebook/model_ebook.dart';
import 'package:ebook_app/widget/shared_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:startapp_sdk_flutter/startapp_sdk_flutter.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

// ignore: must_be_immutable
class EbookDetail extends StatefulWidget {

  int ebookId;
  int status;

  EbookDetail({required this.ebookId, required this.status});

  @override
  _EbookDetailState createState() => _EbookDetailState();
}

class _EbookDetailState extends State<EbookDetail> {

  Future<List<ModelEbook>>? getDetail;
  List<ModelEbook> listDetail = [];
  String checkFavorite = "0", id = "", name = "", email = "", photo = "";
  SharedPreferences? preferences;
  RewardedAd? _rewardedAd;
  bool _isBannerAdReady = false;
  late BannerAd _bannerAd;
  String admobReward = '', admobBanner = '', adsMode = '';
  String startAppLiveMode = '', androidAppId = '', iosAppId = '', accountAppId = '';
  String androidGameId = '', iosGameId = '', androidBanner = '', androidInterstitial = '', androidReward = '', unityLiveMode = '0';

  @override
  void initState() {
    super.initState();
    fetchAdsSetup().then((value) {
      setState(() {
        adsMode = value[0].ads;
        admobReward = value[0].admobReward;
        admobBanner = value[0].banner;
        androidBanner = value[0].unityBanner;
        androidReward = value[0].unityReward;
        startAppLiveMode = value[0].startAppLIveMode;
        androidAppId = value[0].androidAppId;
        iosAppId = value[0].iosAppId;
        accountAppId = value[0].startAppAccountId;
        androidGameId = value[0].unityGameId;
        unityLiveMode = value[0].unityLiveMode;
        initApp(androidAppId, iosAppId, accountAppId);
        UnityInit().getInit(androidGameId, androidGameId, unityLiveMode);
        _bannerAd = BannerAd(
          adUnitId: AdManager().bannerAdUnitId(admobBanner, admobBanner),
          request: AdRequest(),
          size: AdSize.banner,
          listener: BannerAdListener(
            onAdLoaded: (_) {
              setState(() {
                _isBannerAdReady = true;
              });
            },
            onAdFailedToLoad: (ad, err) {
              print('Failed to load a banner ad: ${err.message}');
              _isBannerAdReady = false;
              ad.dispose();
            },
          ),
        );
        _bannerAd.load();
        _loadRewardedAd(admobReward);
      });
    });
    getDetail = fetchDetail(listDetail, widget.ebookId);
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        checkFavorites(id);
      });
    });
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  checkFavorites(String idUser) async{
    var data = {'id_course': widget.ebookId, 'id_user': idUser};
    var checkFav = await Dio().post(ApiConstant().baseUrl+ApiConstant().checkFavorite, data: data);
    var response = checkFav.data;
    setState(() {
      checkFavorite = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()=>Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Detail', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: FutureBuilder(
          future: getDetail,
          builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(12),
                            height: 25.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    listDetail[index].photo,
                                    fit: BoxFit.cover,
                                    width: 35.w,
                                  ),
                                ),
                                SizedBox(width: 3.w,),
                                Flexible(
                                    child: Column(
                                      children: [
                                        Text(listDetail[index].title, style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 1.5.h,),
                                        Text('Author: ${listDetail[index].authorName}', style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15, fontWeight: FontWeight.w400), maxLines: 5, overflow: TextOverflow.ellipsis,),
                                        SizedBox(height: 1.5.h,),
                                        Text('Publisher: ${listDetail[index].publisherName}', style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15, fontWeight: FontWeight.w400), maxLines: 5, overflow: TextOverflow.ellipsis,),
                                        Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () async{
                                                  await showDialog(
                                                      builder: (fav)=>FutureProgressDialog(
                                                          saveFavorite(
                                                              context: fav,
                                                              idCourse: widget.ebookId.toString(),
                                                              idUser: id)
                                                      ), context: context).then((value) async{
                                                    preferences = await SharedPreferences.getInstance();
                                                    dynamic fav = preferences!.get('saveFavorite');
                                                    setState(() {
                                                      checkFavorite = fav;
                                                    });
                                                  });
                                                },
                                                child: checkFavorite == "already"  ? Icon(
                                                  Icons.bookmark, color: Colors.blue, size: 21.sp,) : Icon(
                                                  Icons.bookmark_border_outlined, color: Colors.black, size: 21.sp,)),
                                            SizedBox(width: 0.6.w,),
                                            Text('${listDetail[index].pages} Pages', style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            SizedBox(width: 2.w,),
                                            listDetail[index].free == 1 ? Text('Free', style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis,) :
                                            Text('Premium', style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            Spacer(),
                                            GestureDetector(
                                              child: Icon(Icons.share_sharp, color: Colors.black, size: 21.sp,),
                                              onTap: ()=>_share(),
                                            ),
                                            SizedBox(width: 3.w,)
                                          ],
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    )
                                ),
                              ],
                            ),
                          ),
                          widget.status == 0 ? Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Coming Soon', style: TextStyle(
                                  color: Colors.white), textAlign: TextAlign.center,),
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 12, right: 12),
                          ) : listDetail[index].free == 1 ? GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blue),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 12, right: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Read Ebook (Free)', style: TextStyle(
                                    color: Colors.white), textAlign: TextAlign.center,),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  PDF(
                                      swipeHorizontal: true,
                                      autoSpacing: false,
                                      fitPolicy: FitPolicy.BOTH
                                  ).cachedFromUrl('${listDetail[index].pdf}',
                                      placeholder: (progress)=> MaterialApp(
                                        home: Scaffold(backgroundColor: Colors.white, body: Center(child: Text('$progress %'),)),
                                      ))));
                            },
                          ) : GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blue),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 12, right: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Read Ebook (Premium)', style: TextStyle(
                                    color: Colors.white), textAlign: TextAlign.center,),
                              ),
                            ),
                            onTap: (){
                              adsMode == "1" ? _rewardedAd?.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    PDF(
                                        swipeHorizontal: true,
                                        autoSpacing: false,
                                        fitPolicy: FitPolicy.BOTH
                                    ).cachedFromUrl('${listDetail[index].pdf}',
                                        placeholder: (progress)=> MaterialApp(
                                          home: Scaffold(backgroundColor: Colors.white, body: Center(child: Text('$progress %'),)),
                                        ))));
                              }) : adsMode == "2" ? _loadRewardedAdUnity(index, androidReward) :
                              _rewardedAd?.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    PDF(
                                        swipeHorizontal: true,
                                        autoSpacing: false,
                                        fitPolicy: FitPolicy.BOTH
                                    ).cachedFromUrl('${listDetail[index].pdf}',
                                        placeholder: (progress)=> MaterialApp(
                                          home: Scaffold(backgroundColor: Colors.white, body: Center(child: Text('$progress %'),)),
                                        ))));
                              });
                            },
                          ),
                          SizedBox(height: 2.h,),
                          //ADS
                          adsMode == "0" ? StartappBanner(
                            listener: handleAds,
                            adSize: StartappBannerSize.BANNER,
                          ) : adsMode == "1" ? _isBannerAdReady ? Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: _bannerAd.size.width.toDouble(),
                              height: _bannerAd.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd),
                            ),
                          ) : Container() : adsMode == "2" ? UnityBannerAd(
                              placementId: AdManager().bannerAdUnitId(androidBanner, androidBanner), listener: (state, arg){
                                print("testLoadUnityAds $state and $arg");
                          },) :
                          Container(),
                          SizedBox(height: 2.h,),
                          Container(
                            padding: EdgeInsets.only(top: 2.h),
                            margin: EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.black12
                            ),
                            child: Column(
                              children: [
                                Text('Description', style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                                Html(
                                  data: '${listDetail[index].description}',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7.h,)
                        ],
                      );
                    },
                  ),
                ],
              );
            }else{
              return Align(
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 1.6, color: Colors.blue,),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _share() async{
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share("Reading free Manga on ${pi.appName}" '\n'"Download now: https://play.google.com/store/apps/details?id=${pi.packageName}");
  }

  void _loadRewardedAd(String admobInterstitial) {
    RewardedAd.load(
      adUnitId: AdManager().rewardedAdUnitId(admobInterstitial, admobInterstitial),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadRewardedAd(admobInterstitial);
            },
          );
        },
        onAdFailedToLoad: (err) {
        },
      ),
    );
  }

  void _loadRewardedAdUnity(int index, String androidReward){
    UnityAds.showVideoAd(
      placementId: AdManagerUnity().rewardedVideoAdPlacementId(androidReward),
      listener: (state, args) async{
        if (state == UnityAdState.complete) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              PDF(
                  swipeHorizontal: true,
                  autoSpacing: false,
                  fitPolicy: FitPolicy.BOTH
              ).cachedFromUrl('pdf here',
                  placeholder: (progress)=> MaterialApp(
                    home: Scaffold(backgroundColor: Colors.white, body: Center(child: Text('$progress %'),)),
                  ))));
        } else if (state == UnityAdState.skipped) {
          showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 10.0.w,
                  vertical: 25.0.h,
                ),
                title: Text('You Skipped Ad', textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                content: Text('If you skip Ad you cant open chapter'), //Text('The Ad not available yet at this moment, please try again later'),
                actions: [
                  TextButton(
                    child: Text('cancel'.toUpperCase(), style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },);
        }
      },
    );
  }
}