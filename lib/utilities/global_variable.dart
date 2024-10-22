import 'dart:io';
const webScreenSize = 600;
const appDownloadLink = 'https://edusapck.page.link/app';

//live ad unit id
final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-5288520752883900/5304623257'
    : 'ca-app-pub-5288520752883900/4625170246';
//live
final adUnitId_reward = Platform.isAndroid
    ? 'ca-app-pub-5288520752883900/1688811875'
    : 'ca-app-pub-5288520752883900/6149465901';
//to optimze app size, run:  flutter build appbundle --target-platform android-arm --analyze-size
//test ad unit id
// final adUnitId = Platform.isAndroid
//     ? 'ca-app-pub-3940256099942544/6300978111'
//     : 'ca-app-pub-3940256099942544/2934735716';
// final adUnitId_reward = Platform.isAndroid
//     ? 'ca-app-pub-3940256099942544/5224354917'
//     : 'ca-app-pub-3940256099942544/1712485313';