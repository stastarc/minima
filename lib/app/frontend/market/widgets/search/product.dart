import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class WidthProductItem extends StatelessWidget {
  final Product product;
  final double width;
  final VoidCallback? onPressed;

  const WidthProductItem({
    super.key,
    required this.product,
    required this.onPressed,
    this.width = 98,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      )),
      height: 145,
      child: TextButton(
          onPressed: onPressed,
          child: Row(
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
                      child: CDN.image(
                          id: product.image, errorComment: '상품 이미지\n준비중'),
                    )),
              ),
              const SizedBox(height: 4),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width - width - 50,
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A1A1A)),
                        ),
                      ),
                      SizedBox(
                        width: size.width - width - 50,
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF5E5E5E)),
                        ),
                      ),
                      Text('${currencyFormat(product.price)}원',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              letterSpacing: .3,
                              color: Color(0xFF4fc083))),
                      Row(children: [
                        RatingBarIndicator(
                            rating: product.rating.toDouble(),
                            itemSize: 20,
                            itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.rating})',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D3D3D)),
                        )
                      ]),
                    ],
                  ))
            ],
          )),
    );
  }
}

class WidthProductItemSkeleton extends StatelessWidget {
  final double width;

  const WidthProductItemSkeleton({
    super.key,
    this.width = 98,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SkeletonBox(width: width, height: width),
          const SizedBox(height: 4),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonText(
                    wordLengths: const [15, 12],
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  SkeletonText(
                    wordLengths: const [8],
                    fontSize: 20,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
