import 'package:flutter/cupertino.dart';
import 'package:minima/app/models/market/product.dart';
import 'product.dart';

class ProductRow extends StatelessWidget {
  final List<Product> products;
  final Iterable<Widget> Function(Iterable<ProductItem>) productBuilder;
  final void Function(Product) onPressed;

  const ProductRow(
      {super.key,
      required this.products,
      required this.productBuilder,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 270,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: productBuilder(products.map((product) =>
              ProductItem.fromProduct(
                  product: product,
                  onPressed: () => onPressed(product)))).toList(),
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
    this.width = 135,
    this.height = 270,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 270,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          const SizedBox(width: 24),
          for (var i = 0; i < count * 2; i++)
            i % 2 == 0
                ? const ProductItemSkeleton()
                : const SizedBox(width: 32),
        ]));
  }
}
