import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/market/rating.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class RatingItem extends StatelessWidget {
  final ProductRating rating;

  const RatingItem({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${rating.writer?.nickname ?? '익명'} (${dateFormat(rating.updatedAt)})',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555)),
          ),
          RatingBarIndicator(
              rating: rating.rating.toDouble(),
              itemSize: 22,
              itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )),
          const SizedBox(height: 8),
          Text(
            rating.comment,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (rating.images.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    for (var image in rating.images)
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  right: rating.images.last == image ? 0 : 8),
                              child: CDN.image(
                                  id: image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover))),
                  ],
                ),
              ),
            ),
          const Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}

class RatingItemSkeleton extends StatelessWidget {
  const RatingItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SkeletonText(
          wordLengths: [12, 10],
          fontSize: 14,
          lineHeight: .3,
        ),
        const SizedBox(height: 8),
        const SkeletonText(
          wordLengths: [30, 32, 20],
          fontSize: 15,
          lineHeight: .3,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(6, 8, 0, 8),
          height: 140,
          child: Row(
            children: [
              for (var i = 0; i < 2; i++)
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                        child: const SkeletonBox(
                          width: double.infinity,
                          height: double.infinity,
                        ))),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.black12,
        ),
      ]),
    );
  }
}
