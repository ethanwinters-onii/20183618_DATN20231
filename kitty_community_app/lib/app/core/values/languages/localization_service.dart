import 'dart:io';
import 'dart:ui';

import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/core/values/languages/from/en_EN.dart';
import 'package:kitty_community_app/app/core/values/languages/from/vi_VN.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class LocalizationService extends Translations {
  static final locale = _getLocaleFromLanguage();

  //static final locale = Get.locale;

  static const fallbackLocale =
      Locale(LanguageCodeConstant.VI, LanguageCountryConstant.VI);

  static final langCodes = [LanguageCodeConstant.EN, LanguageCodeConstant.VI];

  static final locales = [
    const Locale(LanguageCodeConstant.EN, LanguageCountryConstant.EN),
    const Locale(LanguageCodeConstant.VI, LanguageCountryConstant.VI),
  ];

  static void changeLocale(String langCode) {
    final locale = _getLocaleFromLanguage(langCode: langCode);
    // LocalStorage().put(LocalDBConstants.LANGUAGE, langCode);
    HiveStorage.box.put(LocalDBConstants.LANGUAGE, langCode);
    Get.updateLocale(locale!);
  }

  static Locale? _getLocaleFromLanguage({String? langCode}) {
    String? languageCode = HiveStorage.box.get(LocalDBConstants.LANGUAGE) ??
        "en";
    var lang = langCode ?? languageCode;

    // LocalStorage().put(LocalDBConstants.LANGUAGE, lang);
    HiveStorage.box.put(LocalDBConstants.LANGUAGE, lang);

    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) return locales[i];
    }
    return Get.locale;
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'vi_VN': vi};
}
