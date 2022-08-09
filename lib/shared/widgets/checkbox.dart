import 'package:flutter/material.dart';

class PrimaryCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const PrimaryCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
          activeColor: const Color(0xFF54CF87),
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFACACAC)),
              borderRadius: BorderRadius.circular(6)),
          value: value,
          onChanged: onChanged),
    );
  }
}
