import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/environ.dart';
import 'package:minima/shared/widgets/loading.dart';

class CDN {
  static CDN? _instance;
  static CDN get instance => _instance ??= CDN();

  static Uri link(String id) {
    return Environ.api(Environ.cdnServer, '/data/$id');
  }

  static CachedNetworkImage image({
    Color placeholderColor = const Color.fromARGB(255, 192, 195, 210),
    double placeholderSize = 100,
    String errorComment = '이미지 준비중',
    BoxFit? fit,
    double? width,
    double? height,
    required String id,
  }) {
    return CachedNetworkImage(
      fit: fit,
      width: width,
      height: height,
      imageUrl: link(id).toString(),
      placeholder: (_, __) => Center(
        child: Loading(
          color: placeholderColor,
          size: 52 * (placeholderSize / 100),
        ),
      ),
      errorWidget: (_, __, ___) => Center(
        child: Text(errorComment,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 172, 172, 172),
                fontSize: 16 * (placeholderSize / 100))),
      ),
    );
  }
}
