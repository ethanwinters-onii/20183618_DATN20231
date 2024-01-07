import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kitty_community_app/app/core/utils/extensions/datetime_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/compress_image.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/hive_storage.dart';
import 'package:kitty_community_app/app/core/utils/local_storage/local_db_constants.dart';
import 'package:kitty_community_app/app/data/models/comment_model/comment_model.dart';
import 'package:kitty_community_app/app/data/models/event_model/event_model.dart';
import 'package:kitty_community_app/app/data/models/message_model/message.dart';
import 'package:kitty_community_app/app/data/models/notification_model/notification_model.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_data.dart';
import 'package:kitty_community_app/app/data/models/pet_model/pet_models.dart';
import 'package:kitty_community_app/app/data/models/post_model/post_model.dart';
import 'package:kitty_community_app/app/data/models/product_model/product_model.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:http/http.dart' as http;

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
      {required newName, required newAbout, required birthday, required role}) async {
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
      "onFirstLogin": false,
      "role": role
    });
    final accountInfo = HiveStorage.box.get(LocalDBConstants.ACCOUNT_LOCAL);
    accountInfo.name = newName;
    accountInfo.dateOfBirth = birthday;
    accountInfo.description = newAbout;
    accountInfo.role = role;
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
    final accountLocal = AccountLocalHelper.get();
    final followers = accountLocal.follower ?? [];
    final language = HiveStorage.box.get(LocalDBConstants.LANGUAGE);

    final followerAccount = await FirebaseConstants.cloudFirestore
        .collection("users")
        .where("UserId", whereIn: followers)
        .get();
    List<AccountInfo> accounts = [];
    for (var acc in followerAccount.docs) {
      accounts.add(AccountInfo.fromJson(acc.data()));
    }

    if (postModel.image != null && postModel.image != "") {
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

      await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(postModel.postId)
          .set(postModel.toJson());

      for (var follower in accounts) {
        NotificationModel notification = NotificationModel(
          notificationId:
              "${accountLocal.userId}${DateTime.now().millisecondsSinceEpoch.toString()}",
          userNotifyId: accountLocal.userId,
          userReceiveId: follower.userId,
          userNotifyName: accountLocal.name,
          userNotifyAvatar: accountLocal.avatar,
          notifyType: "post",
          notificationContent: "đã cập nhật một trạng thái mới",
          notificationContentEn: "updated a new status",
          notificationCreateAt: DateTime.now().toAPIFormat(),
          postId: postModel.postId,
          eventId: "",
          read: false,
        );

        await FirebaseConstants.cloudFirestore
            .collection("notifications")
            .doc(notification.notificationId)
            .set(notification.toJson());
        sendPushNotification(
            follower,
            language == 'en'
                ? '${accountLocal.name} updated a new status'
                : '${accountLocal.name} đã cập nhật một trạng thái mới',
            accountLocal.name);
      }
    } else {
      await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(postModel.postId)
          .set(postModel.toJson());
      for (var follower in accounts) {
        NotificationModel notification = NotificationModel(
          notificationId:
              "${accountLocal.userId}${DateTime.now().millisecondsSinceEpoch.toString()}",
          userNotifyId: accountLocal.userId,
          userReceiveId: follower.userId,
          userNotifyName: accountLocal.name,
          userNotifyAvatar: accountLocal.avatar,
          notifyType: "post",
          notificationContent: "đã cập nhật một trạng thái mới",
          notificationContentEn: "updated a new status",
          notificationCreateAt: DateTime.now().toAPIFormat(),
          postId: postModel.postId,
          eventId: "",
          read: false,
        );

        await FirebaseConstants.cloudFirestore
            .collection("notifications")
            .doc(notification.notificationId)
            .set(notification.toJson());

        sendPushNotification(
            follower,
            language == 'en'
                ? '${accountLocal.name} updated a new status'
                : '${accountLocal.name} đã cập nhật một trạng thái mới',
            accountLocal.name);
      }
    }
  }

  // Get User All Post
  static Future<List<PostModel>?> getUserPosts(String userId) async {
    try {
      final posts = await FirebaseConstants.cloudFirestore
          .collection("posts")
          .where("userId", isEqualTo: userId)
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

  // GetUserLikePost
  static Future<List<PostModel>?> getUserLikePost(
      List<String> following, String userId) async {
    try {
      List<PostModel> postList = [];
      final posts = await FirebaseConstants.cloudFirestore
          .collection("posts")
          .where("userId", whereIn: following)
          .get();
      for (var post in posts.docs) {
        final postModel = PostModel.fromJson(post.data());
        if (postModel.hearts?.contains(userId) ?? false) {
          postList.add(postModel);
        }
      }

      logger.v(postList[0].toJson());
      return postList.reversed.toList();
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAllFriendPost(
      List<String> following) {
    return FirebaseConstants.cloudFirestore
        .collection("posts")
        .where("userId", whereIn: following)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAPost(
      String postId) {
    return FirebaseConstants.cloudFirestore
        .collection("posts")
        .where("postId", isEqualTo: postId)
        .snapshots();
  }

  static Future<void> updateLikeAPost(PostModel post, String userId) async {
    if (post.hearts?.contains(userId) ?? false) {
      post.hearts?.remove(userId);
    } else {
      post.hearts?.add(userId);
    }
    return await FirebaseConstants.cloudFirestore
        .collection("posts")
        .doc(post.postId)
        .update({"hearts": post.hearts});
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

  /// ---------------------------- [Comment] --------------------------
  static Future<void> writeComment(
      CommentModel comment, int currentNoComments, PostModel post) async {
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    final accountLocal = AccountLocalHelper.get();
    final followers = accountLocal.follower ?? [];
    final language = HiveStorage.box.get(LocalDBConstants.LANGUAGE);

    if (comment.commentImage != null &&
        (comment.commentImage?.isNotEmpty ?? false)) {
      try {
        final file = File(comment.commentImage ?? "");
        final ext = file.path.split('.').last;
        logger.d("Extension: $ext");
        final data = await ImageHelper.compressImage(file, 100);

        final ref = FirebaseConstants.firebaseStorage.ref().child(
            "comments/${comment.userId}/${DateTime.now().millisecondsSinceEpoch}.$ext");

        await ref
            .putFile(data, SettableMetadata(contentType: 'image/$ext'))
            .then((p0) {
          logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
        });

        final imageUrl = await ref.getDownloadURL();
        comment.commentImage = imageUrl;
        await FirebaseConstants.cloudFirestore
            .collection("comments")
            .doc("${comment.postId}${comment.commentId}")
            .set(comment.toJson());
        await FirebaseConstants.cloudFirestore
            .collection("posts")
            .doc(comment.postId)
            .update({"noComment": currentNoComments + 1});

        NotificationModel notification = NotificationModel(
          notificationId:
              "${accountLocal.userId}${DateTime.now().millisecondsSinceEpoch.toString()}",
          userNotifyId: comment.userId,
          userReceiveId: post.userId,
          userNotifyName: accountLocal.name,
          userNotifyAvatar: accountLocal.avatar,
          notifyType: "comment",
          notificationContent: "đã bình luận vào bài viết của bạn",
          notificationContentEn: "commented on your post",
          notificationCreateAt: DateTime.now().toAPIFormat(),
          postId: post.postId,
          eventId: "",
          read: false,
        );
        if (notification.userNotifyId != notification.userReceiveId) {
          await FirebaseConstants.cloudFirestore
              .collection("notifications")
              .doc(notification.notificationId)
              .set(notification.toJson());
        }
      } catch (e) {
        logger.e(e);
        return;
      }
    } else {
      await FirebaseConstants.cloudFirestore
          .collection("comments")
          .doc("${comment.postId}${comment.commentId}")
          .set(comment.toJson());
      await FirebaseConstants.cloudFirestore
          .collection("posts")
          .doc(comment.postId)
          .update({"noComment": currentNoComments + 1});

      NotificationModel notification = NotificationModel(
        notificationId:
            "${accountLocal.userId}${DateTime.now().millisecondsSinceEpoch.toString()}",
        userNotifyId: comment.userId,
        userReceiveId: post.userId,
        userNotifyName: accountLocal.name,
        userNotifyAvatar: accountLocal.avatar,
        notifyType: "comment",
        notificationContent: "đã bình luận vào bài viết của bạn",
        notificationContentEn: "commented on your post",
        notificationCreateAt: DateTime.now().toAPIFormat(),
        postId: post.postId,
        eventId: "",
        read: false,
      );
      if (notification.userNotifyId != notification.userReceiveId) {
        await FirebaseConstants.cloudFirestore
            .collection("notifications")
            .doc(notification.notificationId)
            .set(notification.toJson());
      }
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamComment(
      String postId) {
    return FirebaseConstants.cloudFirestore
        .collection("comments")
        .where("postId", isEqualTo: postId)
        .snapshots();
  }

  static Future<void> updateLikeAComment(
      CommentModel comment, String userId) async {
    if (comment.hearts?.contains(userId) ?? false) {
      comment.hearts?.remove(userId);
    } else {
      comment.hearts?.add(userId);
    }

    return await FirebaseConstants.cloudFirestore
        .collection("comments")
        .doc("${comment.postId}${comment.commentId}")
        .update({"hearts": comment.hearts});
  }

  /// ---------------------------- [Notify] --------------------------
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamUserNotification() {
    final accountLocal = AccountLocalHelper.get();
    return FirebaseConstants.cloudFirestore
        .collection("notifications")
        .where("userReceiveId", isEqualTo: accountLocal.userId)
        .snapshots();
  }

  /// ---------------------------- [Chat] --------------------------
  // stream user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamChatUser(
      AccountInfo chatUser) {
    return FirebaseConstants.cloudFirestore
        .collection("users")
        .where("UserId", isEqualTo: chatUser.userId)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    print("UPDATE");
    final token = await FirebaseConstants.firebaseMessaging.getToken();
    await FirebaseConstants.cloudFirestore
        .collection("users")
        .doc(user.uid)
        .update({
      "isOnline": isOnline,
      "lastActive": DateTime.now().millisecondsSinceEpoch.toString(),
      "deviceToken": token
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAllMessageWith(
      AccountInfo chatUser) {
    return FirebaseConstants.cloudFirestore
        .collection("chats/${getConversationID(chatUser.userId!)}/messages/")
        .snapshots();
  }

  static Future<void> sendMessage(
      AccountInfo chatUser, String msg, MType type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        read: "",
        told: chatUser.userId!,
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = FirebaseConstants.cloudFirestore
        .collection("chats/${getConversationID(chatUser.userId!)}/messages/");

    logger.d(
        "Send message to ${chatUser.name} - ${getConversationID(chatUser.userId!)}");
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == MType.text ? msg : "[Image]"));
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    FirebaseConstants.cloudFirestore
        .collection("chats/${getConversationID(message.fromId)}/messages/")
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      AccountInfo user) {
    return FirebaseConstants.cloudFirestore
        .collection("chats/${getConversationID(user.userId!)}/messages/")
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(AccountInfo chatUser, File file) async {
    final ext = file.path.split('.').last;
    logger.d("Extension: $ext");

    final ref = FirebaseConstants.firebaseStorage.ref().child(
        "chats/${getConversationID(chatUser.userId!)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, MType.image);
  }

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message(doc)

  static Future<void> sendPushNotification(AccountInfo chatUser, String message,
      [String? title]) async {
    try {
      final body = {
        "to": chatUser.deviceToken,
        "notification": {
          "title": title ?? chatUser.name,
          "body": message,
        }
      };
      var response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=${FirebaseConstants.apiKey}"
          });
      logger.d("Response status: ${response.statusCode}");
      logger.d("Response body: ${response.body}");
    } on Exception catch (e) {
      // TODO
      logger.e(e);
    }
  }

  /// ---------------------------- [Product] --------------------------
  static Future<void> createProduct(ProductModel product) async {
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final file = File(product.image ?? "");
      final ext = file.path.split('.').last;
      logger.d("Extension: $ext");
      final data = await ImageHelper.compressImage(file, 100);

      final ref = FirebaseConstants.firebaseStorage.ref().child(
          "products/${product.userId}/${DateTime.now().millisecondsSinceEpoch}.$ext");

      await ref
          .putFile(data, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
      });

      final imageUrl = await ref.getDownloadURL();
      product.image = imageUrl;
      await FirebaseConstants.cloudFirestore
          .collection("products")
          .doc("${product.userId}${product.productId}")
          .set(product.toJson());
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamProducts(
      String userId) {
    return FirebaseConstants.cloudFirestore
        .collection("products")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  /// ---------------------------- [Event] --------------------------
  static Future<void> createEvent(EventModel event) async {
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    final accountLocal = AccountLocalHelper.get();
    final followers = accountLocal.follower ?? [];
    final language = HiveStorage.box.get(LocalDBConstants.LANGUAGE);

    final followerAccount = await FirebaseConstants.cloudFirestore
        .collection("users")
        .where("UserId", whereIn: followers)
        .get();
    List<AccountInfo> accounts = [];
    for (var acc in followerAccount.docs) {
      accounts.add(AccountInfo.fromJson(acc.data()));
    }

    try {
      final file = File(event.bgImage ?? "");
      final ext = file.path.split('.').last;
      logger.d("Extension: $ext");
      final data = await ImageHelper.compressImage(file, 100);

      final ref = FirebaseConstants.firebaseStorage.ref().child(
          "events/${event.userId}/${DateTime.now().millisecondsSinceEpoch}.$ext");

      await ref
          .putFile(data, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        logger.d("Data transferred: ${p0.bytesTransferred / 1000} kb");
      });

      final imageUrl = await ref.getDownloadURL();
      event.bgImage = imageUrl;
      await FirebaseConstants.cloudFirestore
          .collection("events")
          .doc("${event.userId}${event.eventId}")
          .set(event.toJson());

      for (var follower in accounts) {
        NotificationModel notification = NotificationModel(
          notificationId:
              "${accountLocal.userId}${DateTime.now().millisecondsSinceEpoch.toString()}",
          userNotifyId: accountLocal.userId,
          userReceiveId: follower.userId,
          userNotifyName: accountLocal.name,
          userNotifyAvatar: accountLocal.avatar,
          notifyType: "event",
          notificationContent: "đã tạo một sự kiện mới\n${event.eventName}",
          notificationContentEn: "has created new event\n${event.eventName}",
          notificationCreateAt: DateTime.now().toAPIFormat(),
          postId: "",
          eventId: "${event.userId}${event.eventId}",
          read: false,
        );

        await FirebaseConstants.cloudFirestore
            .collection("notifications")
            .doc(notification.notificationId)
            .set(notification.toJson());
        sendPushNotification(
            follower,
            language == 'en'
                ? '${accountLocal.name} has created new event\n${event.eventName}'
                : '${accountLocal.name} đã tạo một sự kiện mới\n${event.eventName}',
            accountLocal.name);
      }
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamUserEvent(
      String userId) {
    return FirebaseConstants.cloudFirestore
        .collection("events")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  static Future<List<EventModel>?> getOtherEvents(String userId) async {
    try {
      final results = await FirebaseConstants.cloudFirestore
          .collection("events")
          .where("userId", isNotEqualTo: userId)
          .get();
      List<EventModel> events = [];
      for (var e in results.docs) {
        final event = EventModel.fromJson(e.data());
        if (event.eventMembers?.contains(userId) ?? false) {
          continue;
        } else {
          events.add(event);
        }
      }
      events.shuffle();
      return events;
    } catch (e) {
      return null;
    }
  }

  static Future<List<EventModel>?> getEventParticipate(String userId) async {
    try {
      final results = await FirebaseConstants.cloudFirestore
          .collection("events")
          .where("userId", isNotEqualTo: userId)
          .get();
      List<EventModel> events = [];
      for (var e in results.docs) {
        final event = EventModel.fromJson(e.data());
        if (event.eventMembers?.contains(userId) ?? false) {
          events.add(event);
        }
      }
      return events;
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateInterestedEvent(EventModel event, String userId) async {
    if (event.eventMembers?.contains(userId) ?? false) {
      event.eventMembers?.remove(userId);
    } else {
      event.eventMembers?.add(userId);
    }
    return await FirebaseConstants.cloudFirestore
        .collection("events")
        .doc("${event.userId}${event.eventId}")
        .update({"eventMembers": event.eventMembers});
  }
}
