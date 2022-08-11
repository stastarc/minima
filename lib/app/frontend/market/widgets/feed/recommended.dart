import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/button.dart';

class RecommendedItem extends StatelessWidget {
  final EdgeInsets padding;
  final String comment;

  const RecommendedItem({
    super.key,
    this.comment = '아직 잘\n모르시겠다고요?',
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(comment,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            PrimaryButton(
                width: double.infinity,
                onPressed: () {},
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  '식물 추천받기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
          ],
        ));
  }
}
