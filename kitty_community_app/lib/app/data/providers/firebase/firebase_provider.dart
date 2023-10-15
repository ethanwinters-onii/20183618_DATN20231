import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_data.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_models.dart';
import 'package:kitty_community_app/app/data/models/user_model/user.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';

class FirebaseProvider {
  static User get user => FirebaseConstants.auth.currentUser!;

  static Future<void> addListPet() async {
    for (var cat in PetData.data) {
      FirebaseConstants.cloudFirestore
          .collection("pets")
          .doc(cat.petId.toString())
          .set(cat.toJson());
    }
  }

  static Future<bool> userExists() async {
    return (await FirebaseConstants.cloudFirestore
            .collection("users")
            .doc(user.uid)
            .get())
        .exists;
  }

  static Future<void> createUser(AccountInfo account) async {
    return await FirebaseConstants.cloudFirestore
        .collection("users")
        .doc(account.userId)
        .set(account.toJson());
  }

  static Future<List<PetModel>?> getAllPet() async {
    try {
      final pets =
          await FirebaseConstants.cloudFirestore.collection("pets").get();
      List<PetModel> petList = [];
      for (var pet in pets.docs) {
        petList.add(PetModel.fromJson(pet.data()));
      }
      logger.v(petList[0].toJson());
      return petList;
    } catch (e) {
      return null;
    }
  }
}
