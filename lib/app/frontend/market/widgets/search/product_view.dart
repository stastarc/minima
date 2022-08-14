import 'package:flutter/material.dart';
import 'package:minima/app/frontend/market/pages/product.dart';
import 'package:minima/app/frontend/market/widgets/feed/recommended.dart';
import 'package:minima/app/frontend/market/widgets/search/product.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/app/models/market/search.dart';
import 'package:minima/routers/_route.dart';

class ProductView extends StatefulWidget {
  final ProductSearch search;
  final bool noRecommended;

  const ProductView({
    super.key,
    required this.search,
    this.noRecommended = false,
  });

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  void onPressed(Product product) {
    Navigator.push(
        context,
        slideRTL(ProductPage(
          productId: product.id,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.search.products.isEmpty) ...[
          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.search, size: 48, color: Color(0xFF3D3D3D)),
          ),
          const SizedBox(height: 8),
          Text(
            "'${widget.search.query}'에 대한\n검색 결과가 없습니다.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5E5E5E),
              decoration: TextDecoration.none,
            ),
          )
        ] else ...[
          for (final product in widget.search.products)
            WidthProductItem(
              product: product,
              onPressed: () => onPressed(product),
            ),
        ],
        if (!widget.noRecommended)
          const RecommendedView(
            comment: '나에게 꼭 맞는\n식물을 추천받고 싶으신가요?',
            padding: EdgeInsets.all(26),
          )
      ],
    );
  }
}

class ProductViewSkeleton extends StatelessWidget {
  const ProductViewSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < 6; i++) const WidthProductItemSkeleton(),
      ],
    );
  }
}
