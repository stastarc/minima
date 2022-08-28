import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/widgets/product/rating_item.dart';
import 'package:minima/app/models/market/rating.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:collection/collection.dart';

class RatingView extends StatefulWidget {
  final int productId;
  final num average;

  ProductRatings? ratings;

  RatingView({
    super.key,
    required this.productId,
    required this.average,
  });

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  dynamic ratings;
  RatingOrderBy orderBy = RatingOrderBy.last;

  late Future<void> initailized;

  Future<void> initailize() async {
    try {
      ratings = await Market.instance.getProductRatings(
        widget.productId,
        orderby: orderBy,
      );
      widget.ratings = ratings;
    } catch (e) {
      ratings = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    ratings = null;
    initailized = initailize();
    setState(() {});
  }

  void onOrderBy(int? order) {
    if (ratings == null) return;
    final orderBy = order == 0
        ? RatingOrderBy.last
        : order == 1
            ? RatingOrderBy.high
            : RatingOrderBy.low;
    if (orderBy == this.orderBy) return;
    this.orderBy = orderBy;
    retry();
  }

  @override
  void initState() {
    super.initState();
    if (widget.ratings == null) {
      initailized = initailize();
    } else {
      ratings = widget.ratings;
      initailized = Future.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(children: [
          const Text(
            '상품평',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black38,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Row(children: [
              RatingBarIndicator(
                  rating: (ratings ?? widget)?.average ?? 0,
                  itemSize: 25,
                  itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )),
              Text('(${(ratings ?? widget)?.average ?? 0})',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              const Text(
                '정렬 기준',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                  value: orderBy == RatingOrderBy.last
                      ? 0
                      : orderBy == RatingOrderBy.high
                          ? 1
                          : 2,
                  items: <String>['최근 순', '별점 높은 순', '별점 낮은 순']
                      .mapIndexed((i, e) => DropdownMenuItem<int>(
                            value: i,
                            child: Text(e,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ))
                      .toList(),
                  onChanged: onOrderBy),
            ]),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black12,
          ),
          FutureBuilder<void>(
              future: initailized,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (ratings == null || ratings is BackendError) {
                    return RetryButton(
                      text: '상품을 가져올 수 없습니다.',
                      error: ratings ?? BackendError.unknown(),
                      onPressed: retry,
                    );
                  } else {
                    var ratings = this.ratings as ProductRatings;
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var rating in ratings.ratings)
                            RatingItem(rating: rating),
                        ]);
                  }
                } else {
                  return Skeleton(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        for (var i = 0; i < 2; i++) const RatingItemSkeleton()
                      ]));
                }
              }),
        ]));
  }
}
