import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/widgets/feed/recommended.dart';
import 'package:minima/app/models/market/feed.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/widgets/retry.dart';

import '../widgets/feed/feed_part.dart';

class FeedPage extends StatefulWidget {
  final List<FeedPart>? feedParts;
  const FeedPage({
    super.key,
    this.feedParts,
  });

  @override
  State createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  dynamic feedData;

  late Future<void> initialized;

  Future<void> initialize() async {
    try {
      feedData = widget.feedParts ?? await Market.instance.getFeeds();
      if (feedData is List<FeedPart>) {
        List<FeedPart> feedParts = feedData as List<FeedPart>;
        await CDN.instance.preloadImages([
          for (var part in feedParts)
            for (var product in part.products) product.image,
        ]);
      }
    } catch (e) {
      feedData = BackendError.fromException(e);
    }
  }

  void retry() {
    initialized = initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialized = initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<void>(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (feedData == null ||
                feedData is BackendError ||
                snapshot.hasError) {
              return RetryButton(
                text: '피드를 가져올 수 없습니다.',
                error: feedData ?? BackendError.unknown(),
                onPressed: retry,
              );
            }

            return Column(children: [
              ...[
                for (final feedPart in feedData!)
                  FeedPartView.fromFeedPart(
                    feedPart: feedPart,
                  )
              ],
              const RecommendedView(
                padding: EdgeInsets.all(26),
              )
            ]);
          } else {
            return Skeleton(
                child: Column(
              children: const [
                FeedPartSkeleton(
                  wordLengths: [15, 12],
                ),
                FeedPartSkeleton(
                  wordLengths: [13, 11],
                )
              ],
            ));
          }
        },
      ),
    ]);
  }
}
