import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

import 'column_header.dart';

class RelatedPlantsView extends StatelessWidget {
  final List<AnalysisReleventPlantData> plants;

  const RelatedPlantsView({super.key, required this.plants});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ColumnHeader(title: '관련 식물', icon: Icons.park_outlined),
        SizedBox(
          width: double.infinity,
          height: 145 + 12 * 2 + 16 + 8,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(
                width: 8,
              ),
              for (var plant in plants) ...[
                Column(
                  children: [
                    Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD1D1D1))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CDN.image(id: plant.image, fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.name.ko ?? '알수없음',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
                SizedBox(
                  width: plants.last == plant ? 8 : 20,
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}
