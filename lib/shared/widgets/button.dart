import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final bool gradient;
  final double borderRadius;
  final bool grey;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;

  const PrimaryButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    this.gradient = true,
    this.borderRadius = 8,
    this.grey = false,
    this.width,
    this.height,
    this.decoration,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius))),
      ),
      child: Ink(
          width: width,
          height: height,
          padding: padding,
          decoration: decoration ??
              BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                  gradient: grey
                      ? null
                      : const LinearGradient(
                          colors: [
                            Color(0xFF55CF94),
                            Color(0xFF53CE78),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: grey ? const Color(0xFFB1B1B1) : null),
          child: child),
    );
  }
}
