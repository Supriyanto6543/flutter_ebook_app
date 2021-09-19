import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/ads/admob.dart';
import 'package:ebook_app/contoller/ads/con_ads.dart';
import 'package:ebook_app/contoller/ads/startapp.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/contoller/con_category.dart';
import 'package:ebook_app/contoller/con_coming.dart';
import 'package:ebook_app/contoller/con_latest.dart';
import 'package:ebook_app/contoller/con_slider.dart';
import 'package:ebook_app/model/category/model_category.dart';
import 'package:ebook_app/model/ebook/model_ebook.dart';
import 'package:ebook_app/view/detail/ebook_detail.dart';
import 'package:ebook_app/view/search/search.dart';
import 'package:ebook_app/widget/ebook_routers.dart';
import 'package:ebook_app/widget/shared_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:startapp_sdk_flutter/startapp_sdk_flutter.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<List<ModelEbook>>? getSlider;
  List<ModelEbook> listSlider = [];

  Future<List<ModelEbook>>? getLatest;
  List<ModelEbook> listLatest = [];

  Future<List<ModelCategory>>? getCategory;
  List<ModelCategory> listCategory = [];

  Future<List<ModelEbook>>? getComing;
  List<ModelEbook> listComing = [];

  String id = '', name = '', email = '', photo = "";
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  String admobBanner = '', admobInterstitial = '', adsMode = '';
  String startAppLiveMode = '', androidAppId = '', iosAppId = '', accountAppId = '';
  String androidBanner = '';

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    getSlider = fetchSlider(listSlider);
    getLatest = fetchLatest(listLatest);
    getCategory = fetchCategory(listCategory);
    getComing = fetchComing(listComing);
    fetchAdsSetup().then((value) {
      setState(() {
        adsMode = value[0].ads;
        admobBanner = value[0].banner;
        androidBanner = value[0].unityBanner;
        admobInterstitial = value[0].interstitial;
        startAppLiveMode = value[0].startAppLIveMode;
        androidAppId = value[0].androidAppId;
        iosAppId = value[0].iosAppId;
        accountAppId = value[0].startAppAccountId;
        initApp(androidAppId, iosAppId, accountAppId);
        _loadInterstitialAd(admobInterstitial);
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
      });
    });
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        photo = value[3];
        getPhoto(id);
      });
    });
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  Future getPhoto(String idUser) async{
    var response = await Dio().post(ApiConstant().baseUrl+ApiConstant().viewPhoto, data: {'id': idUser});
    var decode = response.data;
    if(decode != "no_img"){
      setState(() {
        photo = decode;
      });
    }else{
      setState(() {
        photo = "";
      });
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white70,
          title:  Row(
            children: [
              Container(
                child: photo == '' ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.asset('assets/image/register.png',
                        fit: BoxFit.cover, width: 12.w, height: 6.h)) :
                ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.network('$photo', width: 12.w, height: 6.h, fit: BoxFit.cover,)),
              ),
              SizedBox(width: 2.w,),
              Text('Hello $name', style: TextStyle(
                  color: Colors.black
              ),)
            ],
          ),
          actions: [
            EbookSearch(),
          ],
        ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getSlider,
            builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return Column(
                  children: [
                    //SLIDER
                    Container(
                      child: FutureBuilder(
                          future: getSlider,
                          builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox(
                                height: 27.0.h,
                                child: Swiper(
                                    autoplay: false,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            margin: const EdgeInsets.all(0.2),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  child: Image.network(
                                                    listSlider[index].photo,
                                                    fit: BoxFit.fitWidth,
                                                    width: 100.0.w,),
                                                  borderRadius: BorderRadius.circular(13),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(13),
                                                        bottomRight: Radius.circular(13),
                                                      ),
                                                      gradient: LinearGradient(
                                                        end: const Alignment(0.0, -1),
                                                        begin: const Alignment(0.0, 0.2),
                                                        colors: <Color>[
                                                          const Color(0x8A000000),
                                                          Colors.black12.withOpacity(0.0)
                                                        ],
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(listSlider[index].title, style: const TextStyle(fontWeight: FontWeight.w500,
                                                          fontSize: 17,
                                                          color: Colors.white)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          pushPage(context, EbookDetail(ebookId: listSlider[index].id,
                                              status: listSlider[index].statusNews));
                                        },
                                      );
                                    }
                                ),
                              );
                            }else{
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.6,
                                ),
                              );
                            }
                          }
                      ),
                    ),
                    //Latest
                    Container(
                      child: FutureBuilder(
                        future: getLatest,
                        builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('Latest', style: TextStyle(
                                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500
                                  ),),
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if(index == snapshot.data!.length){
                                        return GestureDetector(
                                          child: Container(
                                            width: 24.0.w,
                                            padding: EdgeInsets.only(top: 10.0.h),
                                            child: Text('See All', style: TextStyle(
                                                color: Colors.blue
                                            ), textAlign: TextAlign.center,),
                                          ),
                                          onTap: (){

                                          },
                                        );
                                      }else{
                                        return GestureDetector(
                                          onTap: (){
                                            pushPage(context, EbookDetail(ebookId: listLatest[index].id, status: listLatest[index].statusNews));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  child: Image.network(
                                                    '${listLatest[index].photo}',
                                                    height: 15.0.h,
                                                    width: 24.0.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                SizedBox(height: 0.5.h,),
                                                Container(
                                                  width: 24.0.w,
                                                  child: Text('${listLatest[index].title}', style: TextStyle(
                                                      color: Colors.black
                                                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  height: 22.0.h,
                                ),
                              ],
                            );
                          }else{
                            return Center();
                          }
                        },
                      ),
                    ),
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
                    //Coming
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: getComing,
                        builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return snapshot.data!.length == 0 ? Container() :
                            Container(
                              color: Colors.blueGrey.withOpacity(0.5),
                              padding: EdgeInsets.only(top: 2.0.h),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text('Coming Soon', style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.bold,
                                          fontSize: 35, letterSpacing: 9
                                      ), textAlign: TextAlign.center,),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 5.0.h),
                                    ),
                                  ),
                                  SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            pushPage(context, EbookDetail(ebookId: listComing[index].id, status: listComing[index].statusNews));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  child: Image.network(
                                                    '${listComing[index].photo}',
                                                    height: 15.0.h,
                                                    width: 24.0.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                SizedBox(height: 0.5.h,),
                                                Container(
                                                  width: 24.0.w,
                                                  child: Text('${listComing[index].title}', style: TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.w500
                                                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    height: 22.0.h,
                                  ),
                                ],
                              ),
                            );
                          }else{
                            return Center();
                          }
                        },
                      ),
                    ),
                    //Category
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: getCategory,
                        builder: (BuildContext context, AsyncSnapshot<List<ModelCategory>> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('Category', style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: (){

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.network(
                                                  '${listCategory[index].photoCat}',
                                                  height: 14.0.h,
                                                  width: 26.0.w,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              ClipRRect(
                                                child: Container(
                                                  color: Colors.black.withOpacity(0.7),
                                                  height: 14.0.h,
                                                  width: 26.0.w,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              Positioned(
                                                child: Center(
                                                  child: Text('${listCategory[index].name}', style: TextStyle(
                                                      color: Colors.white, fontWeight: FontWeight.w500
                                                  ), maxLines: 1, textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,),
                                                ),
                                                bottom: 0, top: 0, right: 0, left: 0,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  height: 14.0.h,
                                ),
                              ],
                            );
                          }else{
                            return Center();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                  ),
                );
              }
            },
          ),
        ),
      )
    );
  }

  void _loadInterstitialAd(String admobInterstitial) {
    InterstitialAd.load(
      adUnitId: AdManager().interstitialAdUnitId(admobInterstitial, admobInterstitial),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          /*ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              pushPage(context, AllEbook());
            },
          );*/

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }
}
