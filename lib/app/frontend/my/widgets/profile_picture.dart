import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minima/app/backend/cdn/cdn.dart';

class ProfilePicture extends StatelessWidget {
  final String? image;
  final double? size;

  const ProfilePicture({
    super.key,
    this.image,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: image == null
          ? SvgPicture.asset(
              'assets/images/icons/profile.svg',
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : CDN.image(
              id: image,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholderSize: min(100, size ?? 100)),
    );
  }
}
