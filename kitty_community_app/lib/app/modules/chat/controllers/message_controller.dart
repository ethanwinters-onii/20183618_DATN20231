import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/message_model/message.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

import '../../../core/utils/extensions/logger_extension.dart';
import '../../../data/models/user_model/account_info.dart';

class MessageController extends BaseController {
  AccountInfo selectedFriend = Get.arguments;

  final FocusNode focusNode = FocusNode();
  final TextEditingController chatController =
      TextEditingController(text: kDebugMode ? "" : null);
  final ScrollController scrollController = ScrollController();

  RxBool showEmoji = false.obs;
  final ImagePicker picker = ImagePicker();

  // RxList<Message> messages = <Message>[
  //   Message(
  //       msg: "Hello, how are you today?",
  //       read: "1683879770441",
  //       told: "ZT8DjaE36rZ2M8pLMZ0aWHE20Dc2",
  //       type: MType.text,
  //       fromId: "V22N3H9scGT3SvD7SsYm5HNsPGb2",
  //       sent: "1683865148573"),
  //   Message(
  //       msg: "I'm good, how about you?",
  //       read: "1683879770441",
  //       told: "V22N3H9scGT3SvD7SsYm5HNsPGb2",
  //       type: MType.text,
  //       fromId: "ZT8DjaE36rZ2M8pLMZ0aWHE20Dc2",
  //       sent: "1683865148573"),
  //   Message(
  //       msg: "Oh, I’m feeling really grateful for this beautiful day",
  //       read: "",
  //       told: "ZT8DjaE36rZ2M8pLMZ0aWHE20Dc2",
  //       type: MType.text,
  //       fromId: "V22N3H9scGT3SvD7SsYm5HNsPGb2",
  //       sent: "1683865148573"),
  //   Message(
  //       msg: "Great, would you like a lemon tart? I have made it.",
  //       read: "",
  //       told: "V22N3H9scGT3SvD7SsYm5HNsPGb2",
  //       type: MType.text,
  //       fromId: "ZT8DjaE36rZ2M8pLMZ0aWHE20Dc2",
  //       sent: "1683865148573"),
  // ].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    focusNode.addListener(_onFocus);
    setStatus(Status.success);
    return super.initialData();
  }

  void _onFocus() {
    if (focusNode.hasFocus) {
      showEmoji.value = false;
    }
  }

  void onShowEmoji() {
    showEmoji.value = !showEmoji.value;
    if (showEmoji.value) {
      focusNode.unfocus();
    }
  }

  void onSendImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      logger.d("Gallary: ${image.path} --- Mime Type: ${image.mimeType}");
      FirebaseProvider.sendChatImage(selectedFriend, File(image.path));
    }
  }

  void onTakeAPhoto() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      logger.d("Camera: ${image.path} --- Mime Type: ${image.mimeType}");
      FirebaseProvider.sendChatImage(selectedFriend, File(image.path));
    }
  }

  void onSendMessage() async {
    String message = chatController.text.trim();
    logger.w(message);
    if (message != "") {
      FirebaseProvider.sendMessage(selectedFriend, message, MType.text);
    }
    chatController.clear();
  }
}
