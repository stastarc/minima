import 'package:flutter/cupertino.dart';
import 'package:minima/app/models/market/product.dart';
import 'product.dart';

class ProductRow extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onPressed;

  const ProductRow(
      {super.key, required this.products, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length + 2,
          itemBuilder: (context, index) {
            if (index == 0 || index >= products.length) {
              return const SizedBox(width: 2);
            }
            final product = products[index - 1];
            return ProductItem.fromProduct(
                product: product, onPressed: () => onPressed(product));
          },
          separatorBuilder: (context, index) => const SizedBox(width: 4),
        ));
  }
}

class ProductRowSkeleton extends StatelessWidget {
  final int count;
  final double width;
  final double height;

  const ProductRowSkeleton({
    super.key,
    this.count = 3,
    this.width = 130,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          const SizedBox(width: 24),
          for (var i = 0; i < count * 2; i++)
            i % 2 == 0
                ? const ProductItemSkeleton()
                : const SizedBox(width: 32),
        ]));
  }
}
