import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:collection/collection.dart';
import 'package:minima/shared/widgets/button.dart';

import '../../myplant/widgets/guide_sheet.dart';

class DiseaseSheet extends StatelessWidget {
  final AnalysisDiseaseData disease;

  const DiseaseSheet({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final contents = disease.content.split('\n');
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 0, 12),
                child: Column(
                  children: [
                    Text(
                      disease.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contents.first,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF3D3D3D),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                )),
          ],
        )),
        const SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CDN.image(
              id: disease.images.firstOrNull,
              width: 110,
              height: 110,
              fit: BoxFit.cover),
        ),
        const SizedBox(width: 14),
      ]),
      const SizedBox(height: 12),
      if (contents.length > 1) ...[
        const Align(
          alignment: Alignment.topLeft,
          child: ColumnHeader(
            title: '해결방법',
            width: 110,
          ),
        ),
        Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: Text(
            contents.skip(1).join('\n'),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
      if (disease.moreContent.isNotEmpty) ...[
        const Align(
          alignment: Alignment.topLeft,
          child: ColumnHeader(
            title: '상세설명',
            width: 110,
          ),
        ),
        Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: Text(
            disease.moreContent,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF2B2B2B),
              fontSize: 14.5,
            ),
          ),
        ),
      ],
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: PrimaryButton(
              borderRadius: 14,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '닫기',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )))
    ]);
  }
}
