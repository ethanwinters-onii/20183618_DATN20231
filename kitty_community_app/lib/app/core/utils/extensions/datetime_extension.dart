import 'dart:io';

import 'package:intl/intl.dart';

import '../local_storage/hive_storage.dart';
import '../local_storage/local_db_constants.dart';

extension DateTimeExtension on DateTime {
  // format datetime to string
  // vi: dd/MM/yyyy HH:mm:ss, en: MM/dd/yyyy HH:mm:ss
  String toStandardString() {
    String? langCode = HiveStorage.box.get(LocalDBConstants.LANGUAGE) ??
        Intl.shortLocale(Platform.localeName);
    return DateFormat.yMd(langCode).add_Hms().format(this);
  }

  String toAPIFormat() {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(this);
  }

  String toCustomFormat() {
    return DateFormat("HH:mm dd/MM/yyyy").format(this);
  }
}
