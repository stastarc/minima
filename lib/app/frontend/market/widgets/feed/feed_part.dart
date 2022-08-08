import 'package:flutter/material.dart';
import 'package:minima/app/models/market/feed.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

import '../../pages/product.dart';
import 'product_row.dart';

class FeedPartView extends StatefulWidget {
  final String title;
  final FeedSearchType searchType;
  final String content;
  final List<Product> products;

  const FeedPartView({
    super.key,
    required this.title,
    required this.searchType,
    required this.content,
    required this.products,
  });

  static FeedPartView fromFeedPart({
    required FeedPart feedPart,
  }) {
    return FeedPartView(
      title: feedPart.title,
      searchType: feedPart.searchType,
      content: feedPart.content,
      products: feedPart.products,
    );
  }

  @override
  State createState() => _FeedPartViewState();
}

class _FeedPartViewState extends State<FeedPartView> {
  void onProductPressed(Product product) {
    var page = ProductPage(
      productId: product.id,
    );
    Navigator.push(context, slideRTL(page));
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold))),
          ProductRow(
              products: widget.products,
              productBuilder: (products) sync* {
                yield const SizedBox(width: 16);
                for (final product in products) {
                  yield product;
                }
                yield const SizedBox(width: 16);
              },
              onPressed: onProductPressed),
        ]);
  }
}

class FeedPartSkeleton extends StatelessWidget {
  final List<int> wordLengths;

  const FeedPartSkeleton({super.key, this.wordLengths = const [15, 10]});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: SkeletonText(
                fontSize: 30,
                wordLengths: wordLengths,
                lineHeight: .5,
              )),
          const ProductRowSkeleton()
        ]);
  }
}
