import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/widgets/product/bottom_bar.dart';
import 'package:minima/app/frontend/market/widgets/product/content.dart';
import 'package:minima/app/frontend/market/widgets/product/info_warp.dart';
import 'package:minima/app/frontend/market/widgets/product/product_title.dart';
import 'package:minima/app/frontend/market/widgets/product/qna.dart';
import 'package:minima/app/frontend/market/widgets/product/rating.dart';
import 'package:minima/app/frontend/market/widgets/product/tabbar.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/widgets/image_list.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/retry.dart';

import '../../../../shared/error.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({
    super.key,
    required this.productId,
  });

  @override
  State createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Color titleColor = Colors.black45;
  dynamic product;
  late Future<void> initailized;

  Future<void> initailize() async {
    try {
      product = await Market.instance.getProductDetail(widget.productId);
    } catch (e) {
      product = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    initailized = initailize();
  }

  @override
  void initState() {
    super.initState();
    initailized = initailize();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        fullScreen: true,
        titleColor: titleColor,
        child: FutureBuilder<void>(
          future: initailized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (product == null || product is BackendError) {
                return RetryButton(
                  text: '상품을 가져올 수 없습니다.',
                  error: product ?? BackendError.unknown(),
                  onPressed: () {
                    initailized = initailize();
                    setState(() {});
                  },
                );
              } else {
                final product = this.product as ProductDetail;

                return Column(children: [
                  Expanded(
                      child: ListView(children: [
                    ImageListView(
                      images: product.images,
                      errorComment: '상품 이미지\n준비중',
                      height: 400,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                        child: ProductTitle(
                          title: product.title,
                          name: product.name,
                          rating: product.rating.toDouble(),
                        )),
                    InfoWarp(info: product.info),
                    const SizedBox(height: 16),
                    TextTabBar(
                        tabs: const ['상품정보', '상품평', '상품문의'],
                        onTabChanged: (i) {
                          return true;
                        }),
                    ProductContentView(product: product),
                    const SizedBox(height: 16),
                    RatingView(productId: product.id, average: product.rating),
                    const SizedBox(
                      height: 32,
                    ),
                    QnAView(
                      productId: product.id,
                      product: product,
                    ),
                    const SizedBox(
                      height: 8,
                    )
                  ])),
                  ProductBottomBar(product: product),
                ]);
              }
            }
            return Skeleton(
                child: Column(children: [
              Expanded(
                  child: ListView(children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 400 - 16,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(22, 16, 22, 16),
                    child: ProductTitleSkeleton()),
                InfoWarpSkeleton(),
                SizedBox(height: 16),
                TextTabBarSkeleton(),
                SkeletonBox(
                  width: double.infinity,
                  height: 300,
                )
              ])),
            ]));
          },
        ));
  }
}
