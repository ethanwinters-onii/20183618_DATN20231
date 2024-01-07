import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';

class EventTextField extends StatelessWidget {
  EventTextField(
      {super.key,
      required this.labelText,
      required this.txtController,
      this.readOnly = false,
      this.prefixIcon,
      this.maxLine,
      this.validator
    });

  final String labelText;
  final TextEditingController txtController;
  bool readOnly;
  Widget? prefixIcon;
  int? maxLine;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return !readOnly
        ? TextFormField(
            controller: txtController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              label: Text(labelText),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(12)),
              prefixIcon: prefixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            maxLines: maxLine,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          )
        : AbsorbPointer(
            child: TextFormField(
              controller: txtController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                label: Text(labelText),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: secondaryColor),
                    borderRadius: BorderRadius.circular(12)),
                prefixIcon: prefixIcon,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          );
  }
}
