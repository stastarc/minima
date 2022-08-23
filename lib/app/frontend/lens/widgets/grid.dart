import 'package:flutter/material.dart';

List<Widget> buildCameraGrid(BuildContext context) {
  final size = MediaQuery.of(context).size;
  const bottom = 130;
  const offset = 52;
  final gridHeightOffset = (size.height - bottom - offset) / 3.5;
  final gridWidthOffset = size.width / 3.5;

  return [
    for (var i = 1; i <= 2; i++)
      Positioned(
          top: i == 1 ? gridHeightOffset + offset : null,
          bottom: i == 2 ? gridHeightOffset + bottom : null,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.7),
          )),
    for (var i = 1; i <= 2; i++)
      Positioned(
          top: 0,
          bottom: 0,
          left: i == 1 ? gridWidthOffset : null,
          right: i == 2 ? gridWidthOffset : null,
          child: Container(
            width: 1,
            color: Colors.white.withOpacity(0.7),
          ))
  ];
}
