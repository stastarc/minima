import 'package:flutter/material.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

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
            fontSize: 16,
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
          fontSize: 16,
        ),
      ),
    ]);
  }

  Widget buildDisease() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: const [
        Icon(Icons.warning_rounded, color: Colors.red, size: 26),
        SizedBox(width: 8),
        Text(
          '질병 있음',
          style: TextStyle(
            color: Colors.red,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
      const SizedBox(height: 8),
      Text(
        '이 식물은 질병이 있습니다.',
        style: TextStyle(
          color: Colors.red,
          fontSize: 17,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '${disease!.name}',
        style: TextStyle(
          color: Colors.red,
          fontSize: 17,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final hasDisease = disease != null;
    return RCard(
      width: double.infinity,
      color: hasDisease ? const Color(0xFFF8E5E5) : const Color(0xFFD3F1DB),
      child: hasDisease ? buildDisease() : buildHealthy(),
    );
  }
}
