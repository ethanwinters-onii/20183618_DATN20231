import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/compress_image.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_data.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_models.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
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

  static Future<AccountInfo?> getUserById(String id) async {
    final result = await FirebaseConstants.cloudFirestore
        .collection("users")
        .doc(id)
        .get();
    if (result.data() != null) {
      return AccountInfo.fromJson(result.data()!);
    } else {
      return null;
    }
  }

  static Future<void> updateUserInfo(
      {required newName, required newAbout, required birthday}) async {
    // update: If no document exists yet, the update will fail.
    // set: Sets data on the document, overwriting any existing data.
    // If the document does not yet exist, it will be created.
    logger.d("Update user info");
    await FirebaseConstants.cloudFirestore
        .collection("users")
        .doc(user.uid)
        .update({
      "Name": newName,
      "description": newAbout,
      "dateOfBirth": birthday,
      "onFirstLogin": false
    });
    final accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
    accountInfo.name = newName;
    accountInfo.dateOfBirth = birthday;
    accountInfo.description = newAbout;
    AccountLocalHelper.save(accountInfo);
  }

  static Future<void> uploadProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    logger.d("Extension: $ext");

    final ref = FirebaseConstants.firebaseStorage
        .ref()
        .child("profile_picture/${user.uid}.$ext");

    final data = await ImageHelper.compressImage(file, 100);
    await ref
        .putFile(data, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
    });

    final url = await ref.getDownloadURL();
    final accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
    accountInfo.avatar = url;
    AccountLocalHelper.save(accountInfo);
    await FirebaseConstants.cloudFirestore
        .collection("users")
        .doc(user.uid)
        .update({"avatar": url, "onFirstLogin": false});
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

  // post
  // Create
  static Future<void> createNewPost(PostModel postModel) async {
    if (postModel.image != null || postModel.image != "") {
      final file = File(postModel.image!);
      final ext = file.path.split('.').last;
      logger.d("Extension: $ext");

      final ref = FirebaseConstants.firebaseStorage.ref().child(
          "posts/${user.uid}${DateTime.now().millisecondsSinceEpoch}.$ext");

      final data = await ImageHelper.compressImage(file, 100);
      await ref
          .putFile(data, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
      });

      final url = await ref.getDownloadURL();
      postModel.image = url;
      return await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(postModel.postId)
          .set(postModel.toJson());
    } else {
      return await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(postModel.postId)
          .set(postModel.toJson());
    }
  }

  // Get User All Post
  static Future<List<PostModel>?> getUserPosts() async {
    try {
      final posts = await FirebaseConstants.cloudFirestore
          .collection("posts")
          .where("userId", isEqualTo: user.uid)
          .get();
      List<PostModel> postList = [];
      for (var post in posts.docs) {
        postList.add(PostModel.fromJson(post.data()));
      }
      logger.v(postList[0].toJson());
      return postList;
    } catch (e) {
      return null;
    }
  }

  // Get All Friends Post
  static Future<List<PostModel>?> getAllFriendsPost(
      List<String> following) async {
    try {
      List<PostModel> postList = [];
      for (var p in following) {
        final posts = await FirebaseConstants.cloudFirestore
            .collection("posts")
            .where("userId", isEqualTo: p)
            .get();
        List<PostModel> userPosts = [];
        for (var post in posts.docs) {
          userPosts.add(PostModel.fromJson(post.data()));
        }
        postList.addAll(userPosts.reversed);
      }
      logger.v(postList[0].toJson());
      return postList.reversed.toList();
    } catch (e) {
      return null;
    }
  }

  // Delete a post
  static Future<bool> deleteUserPost(PostModel postModel) async {
    try {
      await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(postModel.postId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ------------------------ [Search - Follow friends] ----------------------------
  static Future<List<AccountInfo>?> getAllUser() async {
    try {
      final results = await FirebaseConstants.cloudFirestore
          .collection("users")
          .where("UserId", isNotEqualTo: user.uid)
          .get();
      List<AccountInfo> accounts = [];
      for (var acc in results.docs) {
        accounts.add(AccountInfo.fromJson(acc.data()));
      }
      logger.v(accounts[0].toJson());
      accounts.shuffle();
      return accounts;
    } catch (e) {
      return null;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAllUser() {
    return FirebaseConstants.cloudFirestore
        .collection("users")
        .where("UserId", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<bool> followingSomeone(AccountInfo account) async {
    try {
      account.follower?.add(user.uid);
      await FirebaseConstants.cloudFirestore
          .collection("users")
          .doc(account.userId)
          .update({"follower": account.follower});

      final accountLocal = AccountLocalHelper.get();
      accountLocal.following?.add(account.userId!);
      await FirebaseConstants.cloudFirestore
          .collection("users")
          .doc(user.uid)
          .update({"following": accountLocal.following});

      AccountLocalHelper.save(accountLocal);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> unFollowingSomeone(AccountInfo account) async {
    try {
      account.follower?.remove(user.uid);
      await FirebaseConstants.cloudFirestore
          .collection("users")
          .doc(account.userId)
          .update({"follower": account.follower});

      final accountLocal = AccountLocalHelper.get();
      accountLocal.following?.remove(account.userId!);
      await FirebaseConstants.cloudFirestore
          .collection("users")
          .doc(user.uid)
          .update({"following": accountLocal.following});
      
      AccountLocalHelper.save(accountLocal);
      return true;
    } catch (e) {
      return false;
    }
  }
}
