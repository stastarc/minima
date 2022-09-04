import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/rounded_card.dart';
import 'package:collection/collection.dart';

import 'disease_sheet.dart';

class DiseaseCard extends StatelessWidget {
  final AnalysisDiseaseData? disease;

  const DiseaseCard({super.key, required this.disease});

  Widget buildHealthy() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: const [
        Icon(Icons.check_circle_rounded, color: Colors.black, size: 24),
        SizedBox(width: 8),
        Text(
          '질병 없음',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
      const SizedBox(height: 8),
      const Text(
        '이 식물은 건강합니다.',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 4),
    ]);
  }

  Widget buildDisease(BuildContext context) {
    void onTab() {
      showSheet(context,
          padding: EdgeInsets.zero, child: DiseaseSheet(disease: disease!));
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CDN.image(
            width: 92,
            height: 92,
            id: disease!.images.firstOrNull,
            fit: BoxFit.cover),
      ),
      const SizedBox(width: 14),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          disease!.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          disease!.content,
          style: const TextStyle(fontSize: 13, color: Color(0xFF3D3D3D)),
        ),
        Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: onTab,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '자세히',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  )
                ],
              ),
            ))
      ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final hasDisease = disease != null;
    return RCard(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: hasDisease ? const Color(0xFFF8E5E5) : const Color(0xFFD3F1DB),
      child: hasDisease ? buildDisease(context) : buildHealthy(),
    );
  }
}
