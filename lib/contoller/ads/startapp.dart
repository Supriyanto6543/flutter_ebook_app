// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:startapp_sdk_flutter/startapp_sdk_flutter.dart';

Future<void> initApp(String androidAppId, String iosAppId, String accountId) async {
  Startapp.instance.initialize(appId: Platform.isAndroid ? androidAppId : iosAppId, accountId: accountId);
}

void handleAds(StartappEvent event) {
  switch (event) {
    case StartappEvent.onClick:
      print('Received: onClick!');
      break;
    case StartappEvent.onReceiveAd:
      print('Received: onReceiveAd');
      break;
    case StartappEvent.onImpression:
      print('Received: onImpression');
      break;
    case StartappEvent.onFailedToReceiveAd:
      print('Received: onFailedToReceiveAd');
      break;
    default:
  }
}