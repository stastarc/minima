import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/pages/search.dart';
import 'package:minima/app/models/market/recommended.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:collection/collection.dart';
import 'package:toast/toast.dart';

class RecommendedView extends StatelessWidget {
  final EdgeInsets padding;
  final String comment;

  const RecommendedView({
    super.key,
    this.comment = '아직 잘\n모르시겠다고요?',
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(comment,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  showSheet(context,
                      child: const RecommendedSheet(),
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24));
                },
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  '식물 추천받기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
          ],
        ));
  }
}

class RecommendedSheet extends StatefulWidget {
  const RecommendedSheet({
    super.key,
  });

  @override
  State createState() => _RecommendedSheetState();
}

class _RecommendedSheetState extends State<RecommendedSheet> {
  final market = Market.instance;
  final List<String> choices = [];
  dynamic recommended;
  late Future<void> initailized;
  int current = 1, checked = -1;
  bool surveyDone = false;

  RecommendedItem? get choice =>
      checked >= 0 ? recommended.items[checked] : null;

  Future<void> initailize() async {
    try {
      if (surveyDone) {
        recommended = choices.join(' ');
        await Future.delayed(const Duration(seconds: 2));
        setState(onDone);
        return;
      } else {
        recommended = await market.getRecommended(id: current);
        var rec = recommended as Recommended;
        if (rec.content.isNotEmpty) choices.add(rec.content);
        await CDN.instance.preloadImages([
          for (var item in rec.items) item.image,
        ]);
      }
    } catch (e) {
      recommended = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    initailized = initailize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initailized = initailize();
  }

  void onPressed(int i, RecommendedItem item) {
    setState(() {
      checked = i;
    });
  }

  void onNext() {
    final choice = this.choice;
    if (choice == null) {
      Toast.show('추천할 식물을 선택해주세요.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }

    if (choice.content.isNotEmpty) choices.add(choice.content);
    current = choice.goto;
    checked = -1;

    if (recommended.isEnd) {
      surveyDone = true;
    }

    retry();
  }

  void onDone() {
    Navigator.pop(context);
    Navigator.push(
        context, fade(SearchPage(query: recommended, noRecommended: true)));
  }

  Widget buildItems(Recommended recommended) {
    final itemCount = recommended.items.length;
    final width = itemCount <= 6 ? 140.0 : 100.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 22),
        child: Text(recommended.title,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      Wrap(
          spacing: 26,
          runSpacing: 16,
          children: recommended.items
              .mapIndexed((i, item) => Column(
                    children: [
                      ClipButton(
                        width: width,
                        height: width,
                        borderRadius: BorderRadius.circular(24),
                        color: i == checked
                            ? Colors.green.withOpacity(.3)
                            : Colors.transparent,
                        onPressed: () => onPressed(i, item),
                        overlay: i == checked
                            ? Center(
                                child: Icon(
                                  Icons.check,
                                  size: width / 2,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        child: CDN.image(id: item.image, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 2),
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ))
              .toList()),
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
          child: PrimaryButton(
              borderRadius: 14,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              grey: checked < 0,
              onPressed: onNext,
              child: const Text(
                '다음',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
        color: Colors.white,
        child: FutureBuilder(
          future: initailized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (recommended == null || recommended is BackendError) {
                return RetryButton(
                  text: '추천 식물을 가져올 수 없습니다.',
                  error: recommended ?? BackendError.unknown(),
                  onPressed: () {
                    initailized = initailize();
                    setState(() {});
                  },
                );
              }
              if (recommended is Recommended) {
                return buildItems(recommended);
              }
            }

            if (surveyDone) return buildAnalysis();
            return Skeleton(child: buildItemsSkeleton());
          },
        ));
  }

  Widget buildItemsSkeleton() {
    const itemCount = 4;
    const width = itemCount <= 6 ? 140.0 : 100.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 20),
        child: SkeletonText(
          wordLengths: [12],
          fontSize: 26,
        ),
      ),
      Wrap(spacing: 26, runSpacing: 16, children: [
        for (var i = 0; i < itemCount; i++)
          Column(
            children: const [
              SkeletonBox(
                width: width,
                height: width,
              ),
              SizedBox(height: 8),
              SkeletonText(
                wordLengths: [7],
                fontSize: 13,
              )
            ],
          )
      ]),
      const Padding(
          padding: EdgeInsets.fromLTRB(20, 26, 20, 0),
          child: SkeletonBox(
            width: double.infinity,
            height: 44,
          ))
    ]);
  }

  Widget buildAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 22),
          child: Text(
            '나에게 꼭 맞는\n식물을 불러오고 있어요.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: const Color(0xFF3D3D3D), size: 52),
          ),
        )
      ],
    );
  }
}
