import 'package:flutter/material.dart';
import 'package:minima/app/models/market/qna.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';

class QnAItem extends StatelessWidget {
  final ProductQnA qna;

  const QnAItem({
    super.key,
    required this.qna,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${qna.writer?.nickname ?? '익명'} (${dateFormat(qna.uploadedAt)})',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555)),
          ),
          const SizedBox(height: 8),
          Text(
            'Q: ${qna.content}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333)),
          ),
          const SizedBox(height: 4),
          Text(
            'A: ${qna.answer ?? '아직 답변이 없습니다.'}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444)),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}

class QnAItemSkeleton extends StatelessWidget {
  const QnAItemSkeleton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonText(wordLengths: const [10], fontSize: 13, lineHeight: .2),
          const SizedBox(height: 8),
          SkeletonText(
              wordLengths: const [17, 14], fontSize: 16, lineHeight: .2),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
