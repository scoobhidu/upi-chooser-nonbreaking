
import 'upi_chooser_platform_interface.dart';

import 'dart:io';
import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'upi_apps_helper.dart';
import 'upi_apps.dart';



class UpiChooser {
  Future<String?> getPlatformVersion() {
    return UpiChooserPlatform.instance.getPlatformVersion();
  }

  final List<String> verifiedFuaApps = [
    UpiAppsHelper.allBank.packageName,
    UpiAppsHelper.amazonPay.packageName,
    UpiAppsHelper.axisPay.packageName,
    UpiAppsHelper.barodaPay.packageName,
    UpiAppsHelper.bhim.packageName,
    UpiAppsHelper.centUpi.packageName,
    UpiAppsHelper.cointab.packageName,
    UpiAppsHelper.corpUpi.packageName,
    UpiAppsHelper.dcbUpi.packageName,
    UpiAppsHelper.finoBPay.packageName,
    UpiAppsHelper.freecharge.packageName,
    UpiAppsHelper.googlePay.packageName,
    UpiAppsHelper.iMobileICICI.packageName,
    UpiAppsHelper.indusPay.packageName,
    UpiAppsHelper.khaaliJeb.packageName,
    UpiAppsHelper.mahaUpi.packageName,
    UpiAppsHelper.mobikwik.packageName,
    UpiAppsHelper.orientalPay.packageName,
    UpiAppsHelper.paytm.packageName,
    UpiAppsHelper.paywiz.packageName,
    UpiAppsHelper.phonePe.packageName,
    UpiAppsHelper.psb.packageName,
    UpiAppsHelper.sbiPay.packageName,
    UpiAppsHelper.yesPay.packageName,
  ];

  List<AppInfo>? installedApps;
  List<AppInfo> androidApps = [
    AppInfo(appName: "G-Pay", packageName: UpiAppsHelper.googlePay.packageName),
    AppInfo(appName: "Paytm", packageName: UpiAppsHelper.paytm.packageName),
    AppInfo(appName: "PhonePe", packageName: UpiAppsHelper.phonePe.packageName),
    AppInfo(appName: "BHIM", packageName: UpiAppsHelper.bhim.packageName),
    // AppInfo(appName: "CRED", packageName: UpiAppsHelper..packageName,),
    AppInfo(
        appName: "Amazon", packageName: UpiAppsHelper.amazonPay.packageName),
    // AppInfo(appName: "My Airtel", packageName: UpiAppsHelper..packageName,),
  ];

  List<AppInfo> iOSApps = [
    AppInfo(appName: "G-Pay", packageName: "gpay://"),
    AppInfo(appName: "Paytm", packageName: "paytmmp://"),
    AppInfo(appName: "PhonePe", packageName: "phonepe://"),
    AppInfo(appName: "BHIM", packageName: "bhim://"),
    AppInfo(appName: "CRED", packageName: "credpay://"),
    AppInfo(appName: "Amazon", packageName: "amazon://"),
    AppInfo(appName: "My Airtel", packageName: "myairtel://"),
  ];

  List<String> upiAndroidIcons = [
    UpiAppsHelper.gpayImg,
    UpiAppsHelper.paytmImg,
    UpiAppsHelper.phonepeImg,
    UpiAppsHelper.bhimImg,
    // UpiAppsHelper.credImg,
    UpiAppsHelper.amazonImg,
    // UpiAppsHelper.amazonImg,
  ];
  List<String> upiIosIcons = [
    UpiAppsHelper.gpayImg,
    UpiAppsHelper.paytmImg,
    UpiAppsHelper.phonepeImg,
    UpiAppsHelper.bhimImg,
    UpiAppsHelper.credImg,
    UpiAppsHelper.amazonImg,
    UpiAppsHelper.amazonImg,
  ];

  List<UpiApps> upiAppsMapList = [];

  Future<List<UpiApps>> getUpiAppList({String? pkgName}) async {
    try {
      upiAppsMapList.clear();
      if (Platform.isAndroid) {
        for (int i = 0; i < androidApps.length; i++) {
          try {
            await AppCheck.checkAvailability(androidApps[i].packageName).then(
              (app) => debugPrint(app.toString()),
            );
            debugPrint('upiAndroidIcons[i]: ${upiAndroidIcons[i]}');
            upiAppsMapList.add(
              UpiApps(
                id: i,
                displayName: androidApps[i].appName,
                appUri: androidApps[i].packageName,
                isAvailable: true,
                scheme: androidApps[i].packageName,
                imageData:
                    (await NetworkAssetBundle(Uri.parse(upiAndroidIcons[i]))
                            .load(upiAndroidIcons[i]))
                        .buffer
                        .asUint8List(),
              ),
            );
          } catch (e) {
            debugPrint('isAppAvailable | for | e: $e');
          }
          debugPrint('$i');
        }
      } else {
        for (int i = 0; i < iOSApps.length; i++) {
          try {
            await AppCheck.checkAvailability(iOSApps[i].packageName).then(
              (app) => debugPrint(app.toString()),
            );
            upiAppsMapList.add(
              UpiApps(
                id: i,
                displayName: iOSApps[i].appName,
                appUri: iOSApps[i].packageName,
                isAvailable: true,
                scheme: iOSApps[i].packageName.split(':')[0],
                imageData:
                    //  await rootBundle.load(upiIosIcons[i]) as Uint8List,
                    (await NetworkAssetBundle(Uri.parse(upiIosIcons[i]))
                            .load(upiIosIcons[i]))
                        .buffer
                        .asUint8List(),
              ),
            );
          } catch (e) {
            debugPrint('isAppAvailable | for | e: $e');
          }
          debugPrint('$i');
        }
      }
      return upiAppsMapList;
    } catch (e) {
      debugPrint('isAppAvailable | e: $e');
      return upiAppsMapList;
    }
  }

  Widget builUpiAppsList() {
    List<Widget> upiAppsList = [];
    debugPrint("lyraProvider.upiAppsMapList.length: ${upiAppsMapList.length}");
    for (int i = 0; i < upiAppsMapList.length; i++) {
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Text(upiAppsMapList[i].displayName ?? ''),
      );
    }
    return Wrap(
      children: upiAppsList,
    );
  }

  void launchUpiIntent(String schemeVal) {
    launchUrl(Uri(scheme: schemeVal, path: "//upi/pay", queryParameters: {
      "pa": "test@bank",
      "pn": "OnePe",
      "tr": "15330175804633937",
      "tn": "Test",
      "am": "10",
      "cu": "INR",
      "mc": "621"
    }));
  }
}
