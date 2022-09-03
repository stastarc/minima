import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/frontend/lens/widgets/more_text_card.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

import 'column_header.dart';

class RelatedImages extends StatelessWidget {
  final List<String> images;

  const RelatedImages({super.key, required this.images});

  Iterable<Widget> getImages(Iterable<String> images, double itemWidth) sync* {
    for (var image in images) {
      yield ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CDN.image(
            id: image, width: itemWidth, height: 130, fit: BoxFit.cover),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.of(context).size.width * .8) / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ColumnHeader(title: '관련 사진', icon: Eva.image_outline),
        MoreRCard(
            columnMode: true,
            width: double.infinity,
            paddingVertical: 12,
            moreChild: images.length < 2
                ? null
                : Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 12,
                    runSpacing: 12,
                    children: getImages(images.skip(2), itemWidth).toList(),
                  ),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 12,
              children: getImages(images.take(2), itemWidth).toList(),
            )),
      ],
    );
  }
}
