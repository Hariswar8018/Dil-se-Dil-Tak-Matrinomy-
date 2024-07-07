import 'dart:io';

class AdHelper {


  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9794212416902452/7778448205';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9794212416902452/9462500313';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}