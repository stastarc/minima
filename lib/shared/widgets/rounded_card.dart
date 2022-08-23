import 'package:flutter/material.dart';

class RCard extends StatelessWidget {
  final Widget child;
  final Widget? suffix;
  final EdgeInsets padding;
  final Color color;
  final double borderRadius;
  final double? width, height;

  const RCard({
    super.key,
    required this.child,
    this.suffix,
    this.padding = const EdgeInsets.all(12),
    this.color = const Color(0xFFF9F9F9),
    this.borderRadius = 14,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: suffix == null
          ? child
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: child),
                suffix!,
              ],
            ),
    );
  }
}
