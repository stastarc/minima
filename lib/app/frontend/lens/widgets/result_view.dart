import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/widgets/disease_card.dart';
import 'package:minima/app/frontend/lens/widgets/harmfulness.dart';
import 'package:minima/app/frontend/lens/widgets/management.dart';
import 'package:minima/app/frontend/lens/widgets/more_text_card.dart';
import 'package:minima/app/frontend/lens/widgets/related_images.dart';
import 'package:minima/app/frontend/lens/widgets/related_plants.dart';
import 'package:minima/app/frontend/lens/widgets/related_product.dart';
import 'package:minima/app/frontend/lens/widgets/solution.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class AnalysisResultView extends StatelessWidget {
  final AnalysisResultData result;

  const AnalysisResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (!result.info.hasPlant) return buildNotFound(context);

    final plant = result.info.plant!;
    final healthy = result.info.report?.disease?.healthy == true;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(children: [
            Text(
              plant.name.ko ?? '알수없음',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              plant.name.en ?? 'Unknown',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            MoreRCard(
                width: double.infinity,
                moreChild: Text(
                  plant.moreDescription,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
                ),
                child: Text(
                  plant.description,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
                )),
            const SizedBox(height: 18),
            DiseaseCard(disease: healthy ? null : result.info.disease),
            RelatedImages(images: plant.images),
            const SizedBox(height: 18),
            HarmfulnessView(data: plant.content.harmfulness),
            const SizedBox(height: 18),
            ManagementView(data: plant.content.management),
            RelatedPlantsView(plants: plant.releventPlants),
            if (kDebugMode)
              RelatedProductView(products: result.relatedProducts),
          ]),
        ),
        // const BottomSurveryView()
      ],
    );
  }

  Widget buildNotFound(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(children: [
      const SizedBox(height: 12),
      const Icon(Icons.warning_amber_rounded, size: 72, color: Colors.black),
      const Text(
        '식물을 분석하기 어려워요.',
        style: TextStyle(
          color: Colors.black,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        '다음과 같이 촬영하면 더 정확한 결과를 얻을 수 있어요.',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 13,
        ),
      ),
      SolutionView(width: width)
    ]);
  }
}

class AnalysisResultViewSkeleton extends StatefulWidget {
  const AnalysisResultViewSkeleton({super.key});

  @override
  State<AnalysisResultViewSkeleton> createState() =>
      _AnalysisResultViewSkeletonState();
}

class _AnalysisResultViewSkeletonState
    extends State<AnalysisResultViewSkeleton> {
  static const steps = [
    Tuple2(3500, '식물을 분석하고 있어요.'),
    Tuple2(3000, '질병을 분석하고 있어요.'),
    Tuple2(2500, '결과를 종합하고 있어요.')
  ];
  int step = 0;

  Future<void> runStep() async {
    for (final step in steps) {
      await Future.delayed(Duration(milliseconds: step.item1));
      if (!mounted || this.step + 1 >= steps.length) return;
      setState(() => this.step++);
    }
  }

  @override
  void initState() {
    super.initState();
    runStep();
  }

  Widget _buildStep(String text, int status) {
    final widget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: status == 1 ? 18 : 20,
          height: status == 1 ? 18 : 20,
          margin: status == 1 ? const EdgeInsets.all(1) : null,
          child: status == 0
              ? Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF69C590),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : status == 1
                  ? const CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                  : const Icon(BootstrapIcons.check_circle_fill,
                      size: 20, color: Color(0xFF40885E)),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ],
    );
    return status == 1
        ? Skeleton(
            baseColor: const Color(0xFF40885E),
            highlightColor: const Color(0xFF96DBB3),
            period: const Duration(milliseconds: 8000),
            child: widget)
        : widget;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps
              .mapIndexed((i, s) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildStep(
                      s.item2,
                      i < step
                          ? 2
                          : i == step
                              ? 1
                              : 0)))
              .toList()),
    );
  }
}
