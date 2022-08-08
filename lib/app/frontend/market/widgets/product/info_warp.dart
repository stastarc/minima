import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:tuple/tuple.dart';

class InfoWarp extends StatelessWidget {
  final List<Tuple2<String, String>> info;

  const InfoWarp({
    super.key,
    required this.info,
  });

  Widget? specialInfo(String key, String value) {
    switch (key) {
      case '난이도':
        final level = value.contains('쉬움')
            ? 1.0
            : value.contains('보통')
                ? 2.0
                : 3.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54CE8A))),
            RatingBarIndicator(
                itemCount: 3,
                rating: level,
                itemSize: 18,
                itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color(0xFF54CE8A),
                    )),
          ],
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 28,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: [
          for (var inf in info)
            Container(
              width: 162,
              height: 24,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(width: 1.2, color: Color(0xFFF6F6F6)))),
              child: Row(children: [
                const SizedBox(
                  width: 8,
                ),
                Text(inf.item1,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF888888))),
                const Spacer(),
                specialInfo(inf.item1, inf.item2) ??
                    AutoSizeText(inf.item2,
                        minFontSize: 10,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF54CE8A))),
                const SizedBox(
                  width: 8,
                ),
              ]),
            ),
          if (info.length % 2 != 0)
            const SizedBox(
              width: 162,
              height: 24,
            ),
        ],
      ),
    );
  }
}

class InfoWarpSkeleton extends StatelessWidget {
  const InfoWarpSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 28,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < 4; i++)
            SizedBox(
              width: 162,
              height: 24,
              child: SkeletonText(
                wordLengths: [13 + (i % 2 == 0 ? i / 2 : -i / 2)],
                fontSize: 15,
              ),
            ),
        ],
      ),
    );
  }
}
