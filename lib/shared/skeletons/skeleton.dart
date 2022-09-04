import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  const Skeleton({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFF0F0F0),
    this.highlightColor = const Color(0xFFC0C3D2),
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor, highlightColor: highlightColor, child: child);
  }
}
