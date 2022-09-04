import 'package:flutter/cupertino.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final BoxShape shape;

  const SkeletonBox({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 10,
    this.margin,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.all(Radius.circular(radius))
            : null,
        color: const Color.fromARGB(255, 209, 209, 209),
      ),
    );
  }
}
