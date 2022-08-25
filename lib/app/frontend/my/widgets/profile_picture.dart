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
    return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: image == null
              ? SvgPicture.asset('assets/images/icons/profile.svg')
              : CDN.image(id: image),
        ));
  }
}
