import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';


class CustomRadioListTile<T> extends StatelessWidget {
  const CustomRadioListTile(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChange,
      required this.label});

  final T value;
  final T groupValue;
  final Function(T?) onChange;
  final String label;

  Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return secondaryColor;
    }
    return Colors.black38;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Transform.scale(
            scale: 1.3,
            child: Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChange,
              fillColor: MaterialStateColor.resolveWith(getColor),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}