import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/market/rating.dart';
import 'package:minima/shared/number_format.dart';

class RatingItem extends StatelessWidget {
  final ProductRating rating;

  const RatingItem({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '익명 (${dateFormat(rating.updatedAt)})',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555)),
              ),
              RatingBarIndicator(
                  rating: rating.rating.toDouble(),
                  itemSize: 24,
                  itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )),
              const SizedBox(height: 8),
              Text(
                rating.comment,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (rating.images.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  height: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        for (var image in rating.images)
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          rating.images.last == image ? 0 : 8),
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
          )),
    );
  }
}
