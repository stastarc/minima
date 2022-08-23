import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

import 'column_header.dart';

class RelatedImages extends StatelessWidget {
  final List<String> images;

  const RelatedImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    // TODO: 가로로
    final itemWidth = (MediaQuery.of(context).size.width * .8) / 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ColumnHeader(title: '관련 사진', icon: Icons.image_outlined),
        RCard(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: images.sublist(0, 3).map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CDN.image(
                  id: image, width: itemWidth, height: 130, fit: BoxFit.cover),
            );
          }).toList(),
        )),
      ],
    );
  }
}
