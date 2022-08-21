import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/frontend/myplant/widgets/diary_card.dart';
import 'package:minima/app/models/myplant/diary.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/image_list.dart';

class DiaryItem extends StatelessWidget {
  final DiaryData diary;
  final DateTime today;
  final bool isEnd;
  final VoidCallback onEdit;

  const DiaryItem({
    super.key,
    required this.diary,
    required this.today,
    required this.isEnd,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = diary.date.difference(today).inDays < 1;
    return DiaryCard(
        date: diary.date,
        isFirst: isFirst,
        isEnd: isEnd,
        suffix: GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit_rounded,
                color: Colors.black38, size: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (diary.images.isNotEmpty) ...[
              ImageListView(
                images: diary.images,
                height: 320,
              ),
              const SizedBox(height: 12),
            ] else if (isFirst) ...[
              PrimaryButton(
                  borderRadius: 0,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  onPressed: onEdit,
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  )),
              const SizedBox(height: 12),
            ],
            SizedBox(
                child: AutoSizeText(
              diary.comment,
              maxLines: 5,
              maxFontSize: 16,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3D3D3D),
                fontWeight: FontWeight.w500,
              ),
            ))
          ],
        ));
  }
}

class DiariesSkeleton extends StatelessWidget {
  final bool hasFirst;

  const DiariesSkeleton({
    this.hasFirst = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Skeleton(
        child: Column(
      children: [
        for (var i = 0; i < 2; i++)
          DiaryCard(
              date: now,
              isSkeleton: true,
              isFirst: hasFirst && i == 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(
                    width: double.infinity,
                    height: 200,
                  ),
                  SizedBox(height: 12),
                  SkeletonText(wordLengths: [22, 16], fontSize: 14),
                ],
              ))
      ],
    ));
  }
}
