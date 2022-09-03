import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class HarmfulnessView extends StatelessWidget {
  final List<AnalysisPlantHarmfulnessData> data;

  const HarmfulnessView({super.key, required this.data});

  Widget buildHarmfulness(AnalysisPlantHarmfulnessData data) {
    dynamic icon;
    String name;

    switch (data.type) {
      case 'dog':
        icon = Ph.dog;
        name = '강아지';
        break;
      case 'cat':
        icon = Ph.cat;
        name = '고양이';
        break;
      default:
        icon = Icons.question_mark;
        name = '알수없음';
    }

    return Row(
      children: [
        if (icon is IconData)
          Icon(
            icon,
            size: 28,
          )
        else
          Iconify(
            icon,
            size: 28,
          ),
        const SizedBox(width: 6),
        RichText(
            text: TextSpan(
                children: [
              TextSpan(text: '$name에게 '),
              TextSpan(
                  text: data.level == 'safe' ? '안전함' : '유해함',
                  style: TextStyle(
                      color: data.level == 'safe'
                          ? const Color(0xFF53CE85)
                          : const Color(0xFFE74747)))
            ],
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RCard(
        width: double.infinity,
        child: Column(
          children: [
            for (var item in data) ...[
              buildHarmfulness(item),
              const SizedBox(height: 4),
              Text(
                item.comment,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: Color(0xFF5D5D5D)),
              ),
              if (item != data.last)
                const Divider(
                  thickness: 1,
                  color: Color(0xFFCDCDCD),
                )
            ],
          ],
        ));
  }
}
