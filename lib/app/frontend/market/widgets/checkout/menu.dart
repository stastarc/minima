import 'package:flutter/material.dart';

class WidthMenuItem extends StatelessWidget {
  final Widget? icon;
  final Widget child;
  final Color? color;
  final bool forward;
  final VoidCallback onPressed;

  const WidthMenuItem({
    super.key,
    this.icon,
    required this.child,
    required this.onPressed,
    this.forward = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Container(
          color: color,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            child,
            if (forward) ...[
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFF3D3D3D),
              ),
            ]
          ])),
    );
  }
}
