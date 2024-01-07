import 'package:flutter/material.dart';

import '../../../core/theme/color_theme.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.focusNode,
    required this.txtController,
    required this.onShowEmoji,
    required this.onSendImage,
    required this.onTakePhoto,
    required this.onSendMessage,
  });

  final FocusNode focusNode;
  final TextEditingController txtController;
  final VoidCallback onShowEmoji;
  final VoidCallback onSendImage;
  final VoidCallback onTakePhoto;
  final VoidCallback onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                IconButton(
                    onPressed: onShowEmoji,
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: customBlueColor,
                    )),
                Expanded(
                    child: Container(
                  constraints: const BoxConstraints(maxHeight: 100),
                  child: SingleChildScrollView(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      focusNode: focusNode,
                      controller: txtController,
                      maxLines: null,
                      decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: "Type something ...",
                          hintStyle: TextStyle(color: customBlueColor),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)
                          ),
                      ),
                      // autofocus: true,
                    ),
                  ),
                )),
                IconButton(
                    onPressed: onSendImage,
                    icon: const Icon(
                      Icons.image,
                      color: customBlueColor,
                    )),
                IconButton(
                    onPressed: onShowEmoji,
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: customBlueColor,
                    )),
              ],
            ),
          ),
        ),
        MaterialButton(
          onPressed: onSendMessage,
          color: Colors.transparent,
          elevation: 0,
          minWidth: 0,
          child: const Icon(
            Icons.send,
            color: customBlueColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
