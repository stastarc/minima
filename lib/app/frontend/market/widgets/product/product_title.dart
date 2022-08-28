import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class ProductTitle extends StatelessWidget {
  final String title;
  final String name;
  final double rating;

  const ProductTitle({
    super.key,
    required this.title,
    required this.name,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 2),
        Text(name,
            maxLines: 2,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 4),
        Row(
          children: [
            RatingBarIndicator(
                rating: rating,
                itemSize: 20,
                itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )),
            const SizedBox(width: 4),
            Text(
              '(${ratingFormat(rating)})',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888)),
            )
          ],
        )
      ],
    );
  }
}

class ProductTitleSkeleton extends StatelessWidget {
  const ProductTitleSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SkeletonText(wordLengths: [18, 8], fontSize: 26),
        SizedBox(height: 2),
        SkeletonText(
          wordLengths: [8, 11],
          fontSize: 16,
          lineHeight: .4,
        ),
      ],
    );
  }
}
