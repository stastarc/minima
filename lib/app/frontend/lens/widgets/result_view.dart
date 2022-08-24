import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/widgets/bottom_survey.dart';
import 'package:minima/app/frontend/lens/widgets/disease_card.dart';
import 'package:minima/app/frontend/lens/widgets/harmfulness.dart';
import 'package:minima/app/frontend/lens/widgets/management.dart';
import 'package:minima/app/frontend/lens/widgets/more_text_card.dart';
import 'package:minima/app/frontend/lens/widgets/related_images.dart';
import 'package:minima/app/frontend/lens/widgets/related_plants.dart';
import 'package:minima/app/frontend/lens/widgets/related_product.dart';
import 'package:minima/app/models/lens/analysis.dart';

class AnalysisResultView extends StatelessWidget {
  final AnalysisResultData result;

  const AnalysisResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (!result.info.hasPlant) return buildNotFound();

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
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              plant.name.en ?? 'Unknown',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 18),
            MoreRCard(
                width: double.infinity,
                moreChild: Text(
                  plant.moreDescription,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
                ),
                child: Text(
                  plant.description,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
                )),
            const SizedBox(height: 18),
            DiseaseCard(disease: healthy ? null : result.info.disease),
            RelatedImages(images: plant.images),
            const SizedBox(height: 18),
            HarmfulnessView(data: plant.content.harmfulness),
            const SizedBox(height: 18),
            ManagementView(data: plant.content.management),
            RelatedPlantsView(plants: plant.releventPlants),
            RelatedProductView(products: result.relatedProducts),
          ]),
        ),
        const BottomSurveryView()
      ],
    );
  }

  Widget buildNotFound() {
    return Column(children: const [
      SizedBox(height: 26),
      Text(
        '식물이 없습니다.',
        style: TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
