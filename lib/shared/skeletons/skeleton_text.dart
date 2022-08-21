import 'package:flutter/cupertino.dart';
import 'skeleton_box.dart';

class SkeletonText extends StatelessWidget {
  final double wordWidth;
  final double fontSize;
  final double radius;
  final double lineHeight;
  final List<num> wordLengths;
  final CrossAxisAlignment crossAxisAlignment;

  const SkeletonText({
    super.key,
    this.wordWidth = .7,
    this.fontSize = 14,
    this.radius = 8,
    this.lineHeight = .2,
    required this.wordLengths,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var length in wordLengths)
          Padding(
            padding: EdgeInsets.only(
                bottom: wordLengths.isNotEmpty ? lineHeight * fontSize : 0),
            child: SkeletonBox(
              width: length * (wordWidth * fontSize),
              height: fontSize,
              radius: radius,
            ),
          ),
      ],
    );
  }
}
