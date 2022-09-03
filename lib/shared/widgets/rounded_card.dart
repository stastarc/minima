import 'package:flutter/material.dart';

class RCard extends StatelessWidget {
  final Widget child;
  final Widget? suffix;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;
  final Color color;
  final double borderRadius;
  final double? width, height;
  final bool columnMode;

  const RCard({
    super.key,
    required this.child,
    this.suffix,
    this.crossAxisAlignment = CrossAxisAlignment.end,
    this.padding = const EdgeInsets.all(12),
    this.color = const Color(0xFFF9F9F9),
    this.borderRadius = 14,
    this.width,
    this.height,
    this.columnMode = false,
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
          : columnMode
              ? Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    child,
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: suffix,
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    Expanded(child: child),
                    suffix!,
                  ],
                ),
    );
  }
}
