import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/market/product.dart';

class ProductContentView extends StatelessWidget {
  final ProductDetail product;

  const ProductContentView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: MarkdownBody(
          selectable: true,
          data: product.content,
          imageBuilder: (uri, title, alt) =>
              CDN.image(id: uri.toString(), absoluteUrl: true),
        ));
  }
}
