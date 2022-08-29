import 'package:flutter/cupertino.dart';

class PrimarySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrimarySwitch({
    super.key,
    this.value = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
