import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_models.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

class PetDiscoveryController extends BaseController {
  RxList<PetModel> petList = <PetModel>[].obs;
  RxList<PetModel> petListOnSearch = <PetModel>[].obs;

  final lang = HiveStorage.box.get(LocalDBConstants.LANGUAGE);
  final PageController pageController = PageController(viewportFraction: 0.8);

  Timer? _timer;

  RxInt currentPage = 0.obs;

  final txtEditingController = TextEditingController();

  RxBool onSearch = false.obs;

  @override
  Future<void> initialData() async {
    // TODO: implement initialData
    getPestList();
    return super.initialData();
  }

  void getPestList() async {
    final result = await FirebaseProvider.getAllPet();
    logger.d(result?.length);
    if (result == null) {
      setStatus(Status.success);
      showErrorDialog(KeyLanguage.c500.tr);
    } else {
      setStatus(Status.success);
      for (var item in result) {
        petList.add(item);
        petListOnSearch.add(item);
      }
      startTimer();
      logger.d(petListOnSearch.length);
    }
  }

  void startTimer() {
    currentPage.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      currentPage++;
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void searchPet(String value) {
    if (value == "") {
      startTimer();
      onSearch.value = false;
      logger.w("1");
      petList.value = [];
      petListOnSearch.addAll(petList);
    } else {
      _timer?.cancel();
      onSearch.value = true;
      logger.w("2");
      petListOnSearch.value = [];
      for (var item in petList) {
        // logger.w(item.name?.toLowerCase());
        if (lang == "en") {
          if (item.enName.toLowerCase().contains(value.toLowerCase())) {
            petListOnSearch.add(item);
          }
        } else {
          if (item.vnName.toLowerCase().contains(value.toLowerCase())) {
            petListOnSearch.add(item);
          }
        }
      }
    }
  }

  void removeSearch() {
    startTimer();
    txtEditingController.text = "";
    onSearch.value = false;
    petListOnSearch.value = [];
    petListOnSearch.addAll(petList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}
