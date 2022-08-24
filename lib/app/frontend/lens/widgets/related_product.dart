import 'package:flutter/material.dart';
import 'package:minima/app/frontend/market/pages/product.dart';
import 'package:minima/app/frontend/market/widgets/feed/product_row.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/routers/_route.dart';

import 'column_header.dart';

class RelatedProductView extends StatelessWidget {
  final List<Product> products;

  const RelatedProductView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ColumnHeader(title: '관련 상품', icon: Icons.shopping_bag_outlined),
        ProductRow(
            products: products,
            productBuilder: (products) sync* {
              for (final product in products) {
                yield product;
              }
            },
            onPressed: (product) {
              Navigator.push(
                  context,
                  slideRTL(ProductPage(
                    productId: product.id,
                  )));
            })
      ],
    );
  }
}
