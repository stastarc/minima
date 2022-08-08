import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const logoSize = [91, 85];

class PLLogo extends StatelessWidget {
  const PLLogo({
    Key? key,
    required this.size,
    this.color = const Color(0xFF4CC760),
  }) : super(key: key);

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: logoSize[1] / logoSize[0] * size,
      child: SvgPicture.asset(
        'assets/images/icons/logo.svg',
        color: color,
        fit: BoxFit.contain,
      ),
    );
  }
}
