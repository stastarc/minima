import 'package:flutter/cupertino.dart';
import 'skeleton_box.dart';

class SkeletonText extends StatelessWidget {
  final double wordWidth;
  final double fontSize;
  final double radius;
  final double lineHeight;
  final List<num> wordLengths;
  final CrossAxisAlignment crossAxisAlignment;

  late final double _wordWidth;
  late final double _lineHeight;

  SkeletonText({
    super.key,
    this.wordWidth = .7,
    this.fontSize = 14,
    this.radius = 8,
    this.lineHeight = .2,
    required this.wordLengths,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    _wordWidth = wordWidth * fontSize;
    _lineHeight = wordLengths.isNotEmpty ? lineHeight * fontSize : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var length in wordLengths)
          Padding(
            padding: EdgeInsets.only(bottom: _lineHeight),
            child: SkeletonBox(
              width: length * _wordWidth,
              height: fontSize,
              radius: radius,
            ),
          ),
      ],
    );
  }
}
