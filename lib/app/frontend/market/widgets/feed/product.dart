import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class ProductItem extends StatelessWidget {
  final Widget image;
  final String title;
  final int price;
  final num rating;
  final VoidCallback? onPressed;
  final double width;

  const ProductItem(
      {super.key,
      this.width = 135,
      required this.image,
      required this.title,
      required this.price,
      required this.rating,
      required this.onPressed});

  static ProductItem fromProduct({
    required Product product,
    required VoidCallback? onPressed,
  }) {
    return ProductItem(
      image: CDN.image(id: product.image, errorComment: '상품 이미지\n준비중'),
      title: product.title,
      price: product.price,
      rating: product.rating,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: TextButton(
          onPressed: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 209, 209, 209))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: width,
                      width: width,
                      child: image,
                    )),
              ),
              const SizedBox(height: 4),
              Container(
                width: width,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A)),
                ),
              ),
              Text('${currencyFormat(price)}원',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: .3,
                      color: Color(0xFF4fc083))),
              Row(children: [
                RatingBarIndicator(
                    rating: rating.toDouble(),
                    itemSize: 20,
                    itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        )),
                const SizedBox(width: 4),
                Text(
                  '($rating)',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D)),
                )
              ]),
            ],
          )),
    );
  }
}

class ProductItemSkeleton extends StatelessWidget {
  final double width;

  const ProductItemSkeleton({super.key, this.width = 135});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: width + 2,
            height: width + 2,
            radius: 10,
          ),
          const SizedBox(height: 8),
          const SkeletonText(
            fontSize: 14,
            wordLengths: [10],
          ),
          const SizedBox(height: 4),
          const SkeletonText(
            fontSize: 18,
            wordLengths: [9],
          ),
          const SkeletonText(
            fontSize: 14,
            wordLengths: [7],
          ),
        ],
      ),
    );
  }
}
