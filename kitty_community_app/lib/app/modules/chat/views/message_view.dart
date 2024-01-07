import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/data/models/message_model/message.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/modules/chat/controllers/message_controller.dart';
import 'package:kitty_community_app/app/modules/chat/widgets/chat_input.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/extensions/logger_extension.dart';
import '../widgets/message_card.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout<MessageController>(
        appBar: AppBar(
          backgroundColor: const Color(0xfffbf5fc),
          automaticallyImplyLeading: false,
          flexibleSpace: StreamBuilder(
              stream:
                  FirebaseProvider.streamChatUser(controller.selectedFriend),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final accounts =
                    data?.map((e) => AccountInfo.fromJson(e.data())).toList() ??
                        [];
                logger.v(accounts.length);
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.keyboard_backspace,
                              color: customBlueColor,
                              size: 32,
                            )),
                        Column(
                          children: [
                            Text(
                              controller.selectedFriend.name ?? "User",
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              accounts.isNotEmpty
                                  ? (accounts[0].isOnline == true
                                      ? "Online"
                                      : "Offline")
                                  : "Offline",
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      controller.selectedFriend.avatar ?? "",
                                  errorWidget: (context, _, __) => ClipRRect(
                                        borderRadius: BorderRadius.circular(32),
                                        child: Container(
                                          width: 45,
                                          height: 45,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                    color: accounts.isNotEmpty
                                        ? (accounts[0].isOnline == true
                                            ? Colors.lightGreen
                                            : primaryColor)
                                        : primaryColor,
                                    shape: BoxShape.circle),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          elevation: 1,
        ),
        child: GestureDetector(
          onTap: () {
            if (controller.focusNode.hasFocus) {
              controller.focusNode.unfocus();
            }
            controller.showEmoji.value = false;
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseProvider.streamAllMessageWith(
                            controller.selectedFriend),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              List<Message> messages = [];
                              for (var i in data!) {
                                logger.d(i.data());
                                messages.add(Message.fromJson(i.data()));
                              }

                              if (messages.isNotEmpty) {
                                return ListView.builder(
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const BouncingScrollPhysics(),
                                    reverse: true,
                                    shrinkWrap: true,
                                    controller: controller.scrollController,
                                    itemCount: messages.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == messages.length) {
                                        return const SizedBox();
                                      }

                                      bool checkMessageRead = false;
                                      if (index == 0) {
                                        if (messages[messages.length - 1]
                                            .read
                                            .isNotEmpty) {
                                          checkMessageRead = true;
                                        }
                                      } else {
                                        if (messages[
                                                    messages.length - index - 1]
                                                .read
                                                .isNotEmpty &&
                                            messages[messages.length - index]
                                                .read
                                                .isEmpty) {
                                          checkMessageRead = true;
                                        }
                                      }
                                      return Column(
                                        children: [
                                          MessageCard(
                                            selectedFriend:
                                                controller.selectedFriend,
                                            message: messages[
                                                messages.length - index - 1],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: AnimatedContainer(
                                              width: checkMessageRead ? 16 : 0,
                                              height: checkMessageRead ? 16 : 0,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                child: CachedNetworkImage(
                                                  imageUrl: controller
                                                          .selectedFriend
                                                          .avatar ??
                                                      "",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                return const Center(
                                  child: Text(
                                    "Say Hi! 👋",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ChatInput(
                      focusNode: controller.focusNode,
                      txtController: controller.chatController,
                      onShowEmoji: controller.onShowEmoji,
                      onSendImage: controller.onSendImage,
                      onTakePhoto: controller.onTakeAPhoto,
                      onSendMessage: controller.onSendMessage),
                  Obx(() {
                    if (controller.showEmoji.value) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: EmojiPicker(
                          textEditingController: controller
                              .chatController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 *
                                (Platform.isIOS
                                    ? 1.30
                                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  })
                ],
              ),
            ),
          ),
        ));
  }
}
