import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/data/models/message_model/message.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:sizer/sizer.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(
      {super.key, required this.selectedFriend, required this.message});

  final AccountInfo selectedFriend;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return message.fromId == FirebaseProvider.user.uid
        ? blueMessage()
        : pinkMessage();
  }

  Widget blueMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                  color:
                      message.type == MType.text ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: message.type == MType.text
                    ? Text(
                        message.msg,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: CachedNetworkImage(
                          imageUrl: message.msg,
                          errorWidget: (context, _, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              width: 32,
                              height: 32,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pinkMessage() {
    if (message.read.isEmpty) {
      FirebaseProvider.updateMessageReadStatus(message);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: CachedNetworkImage(
                  imageUrl: selectedFriend.avatar ?? "",
                  errorWidget: (context, _, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          width: 32,
                          height: 32,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                  color: message.type == MType.text
                      ? Color(0xfffaebfa)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: message.type == MType.text
                    ? Text(
                        message.msg,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: CachedNetworkImage(
                          imageUrl: message.msg,
                          errorWidget: (context, _, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              width: 32,
                              height: 32,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
    );
  }
}
