import 'package:flutter/material.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class DiaryCard extends StatelessWidget {
  final DateTime date;
  final Widget child;
  final Widget? suffix;
  final double dateFontSize, datePosition, dotSize, lineWidth;
  final double? height;
  final bool isFirst, isSkeleton, isEnd;

  const DiaryCard(
      {super.key,
      required this.date,
      required this.child,
      this.suffix,
      this.dateFontSize = 15.0,
      this.datePosition = 34.0,
      this.lineWidth = 52.0,
      this.dotSize = 12.0,
      this.height,
      this.isFirst = false,
      this.isEnd = false,
      this.isSkeleton = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
            padding: EdgeInsets.only(
                left: lineWidth,
                right: lineWidth / 2,
                top: datePosition + dotSize / 3 - dateFontSize / 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  if (isSkeleton)
                    const SkeletonText(
                      wordLengths: [12],
                      fontSize: 15,
                    )
                  else
                    Text(longDateFormat(date),
                        style: TextStyle(fontSize: dateFontSize)),
                  const Spacer(),
                  if (suffix != null) ...[
                    suffix!,
                    const SizedBox(width: 8),
                  ]
                ],
              ),
              const SizedBox(height: 8),
              child,
              if (isEnd) const SizedBox(height: 42),
            ])),
        Positioned(
            top: isFirst ? datePosition : 0,
            bottom: 0,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VerticalDivider(
                  thickness: 1,
                  width: lineWidth,
                  color: Colors.grey[300],
                ),
                Positioned(
                    top: isFirst ? 0 : datePosition,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: const BoxDecoration(
                          color: Color(0xFF55CF8F), shape: BoxShape.circle),
                    )),
              ],
            )),
      ],
    );
  }
}
