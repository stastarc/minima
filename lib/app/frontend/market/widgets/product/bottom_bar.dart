import 'package:flutter/material.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';

import 'buy.dart';

class ProductBottomBar extends StatelessWidget {
  final ProductDetail product;

  const ProductBottomBar({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${currencyFormat(product.price)}원',
                    style: const TextStyle(
                      color: Color(0xFF54CF8D),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.deliveryPrice <= 0
                        ? '무료배송'
                        : '배송비 ${currencyFormat(product.deliveryPrice)}원',
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                product.components
                    .map((e) => '${e.item2} ${e.item1}개')
                    .join(' + '),
                style: const TextStyle(
                  color: Color(0xFF434343),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                showSheet(context,
                    child: BuySheet(product: product),
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 24));
              },
              child: const Text(
                '구매하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ]),
      ),
    );
  }
}

class ProductBottomBarSkeleton extends StatelessWidget {
  const ProductBottomBarSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 22, 14),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SkeletonText(
                wordLengths: [14],
                fontSize: 18,
              ),
              SkeletonText(
                wordLengths: [10],
                fontSize: 16,
              )
            ],
          ),
          const Spacer(),
          const SkeletonBox(
            width: 95,
            height: 40,
          ),
        ]),
      ),
    );
  }
}
