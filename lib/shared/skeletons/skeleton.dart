import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final Widget child;

  const Skeleton({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color.fromRGBO(240, 240, 240, 1),
        highlightColor: const Color.fromARGB(255, 192, 195, 210),
        child: child);
  }
}
