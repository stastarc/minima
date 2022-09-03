import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:minima/app/models/lens/analysis.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class ManagementView extends StatelessWidget {
  final List<AnalysisPlantManagementData> data;

  const ManagementView({super.key, required this.data});

  Widget buildManagement(AnalysisPlantManagementData data) {
    IconData icon;
    String title;

    switch (data.type) {
      case 'sunshine':
        icon = Feather.sun;
        title = '햇빛';
        break;
      case 'moisture':
        icon = Icons.water_drop_outlined;
        title = '수분';
        break;
      case 'temperature':
        icon = FluentIcons.temperature_24_regular;
        title = '온도';
        break;
      case 'pruning':
        icon = FluentIcons.cut_24_filled;
        title = '가지치기';
        break;
      case 'fertilizer':
        icon = Icons.medication_outlined;
        title = '영양제';
        break;
      default:
        icon = Icons.question_mark;
        title = '알수없음';
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 28,
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            RichText(
                text: TextSpan(
                    children: [
                  TextSpan(text: data.comment),
                ],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: Color(0xFF5D5D5D)))),
          ],
        ))
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
              buildManagement(item),
              const SizedBox(height: 4),
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
