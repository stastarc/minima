import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class CardItem extends StatelessWidget {
  final String title;
  final Widget icon, child;
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: RCard(
            width: double.infinity,
            crossAxisAlignment: CrossAxisAlignment.center,
            suffix: child,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C3C3C))),
              ],
            )));
  }
}
