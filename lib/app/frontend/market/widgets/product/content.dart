import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:minima/app/models/market/product.dart';

class ProductContentView extends StatelessWidget {
  final ProductDetail product;

  const ProductContentView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      selectable: true,
      data: product.content,
    );
  }
}
