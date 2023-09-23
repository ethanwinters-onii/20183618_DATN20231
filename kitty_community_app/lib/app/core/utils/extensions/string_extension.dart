import 'dart:io';

import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
// import 'package:pvoil4u/app/core/utils/local_storage/local_storage.dart';
import 'package:intl/intl.dart';

import '../local_storage/hive_storage.dart';

extension StringExtension on String {
  // to currency type, for vi_sample: 50.000, en_sample: 50,000
  String toCurrencyFromLocale() {
    String? langCode = HiveStorage.box.get(LocalDBConstants.LANGUAGE) ??
        Intl.shortLocale(Platform.localeName);
    if (isEmpty) {
      return "";
    } else {
      try {
        return NumberFormat.decimalPattern(langCode).format(int.parse(this));
      } catch (e) {
        return "";
      }
    }
  }

  // to DateTime datatype, sample: "2023-05-30 06:25:58.0"
  DateTime toDateTime() {
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(this);
  }

  // from QRTime to DateTime: sample: yyyyMMddHHmmss
  // DateTime fromQRTimeToDateTime() {
  //   String year = substring(0, 4);
  //   String month = substring(4, 6);
  //   String day = substring(6, 8);
  //   String hour = substring(8, 10);
  //   String minute = substring(10, 12);
  //   String second = substring(12, 14);
  //   this =
  //   return DateFormat('$year-$month-$day $hour:$minute:$second').parse(this);
  // }
}
