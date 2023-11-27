import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';

class ProfileTextField extends StatelessWidget {
  ProfileTextField({
    super.key,
    required this.label,
    required this.txtEditingController,
    required this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController txtEditingController;
  final Widget? prefixIcon;
  Widget? suffixIcon;
  bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        !readOnly
            ? TextFormField(
                controller: txtEditingController,
                readOnly: readOnly,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: secondaryColor),
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    constraints: const BoxConstraints(maxHeight: 42),
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon
                  ),
              )
            : AbsorbPointer(
                child: TextFormField(
                  controller: txtEditingController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: secondaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      constraints: const BoxConstraints(maxHeight: 42),
                      prefixIcon: prefixIcon,
                      suffixIcon: suffixIcon
                    ),
                ),
              )
      ],
    );
  }
}
