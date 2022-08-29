import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;
import 'package:minima/app/backend/environ.dart';
import 'package:minima/shared/widgets/loading.dart';

class CDN {
  static CDN? _instance;
  static CDN get instance => _instance ??= CDN();

  List<int>? fitImage(List<int> img, {int size = 2160, bool ensure = false}) {
    var image = Image.decodeImage(img);
    if (image == null) {
      if (ensure) throw Exception('잘못된 이미지 파일입니다.');
      return null;
    }
    if (image.width > size || image.height > size) {
      image = Image.copyResize(image,
          width: image.width > image.height ? size : null,
          height: image.width < image.height ? size : null);
    }

    return Image.encodeJpg(image, quality: 80);
  }

  Future<List<int>?> fitImagePath(String img,
      {int size = 2160, bool ensure = false}) async {
    return fitImage(await File(img).readAsBytes(), ensure: ensure);
  }

  static Uri link(String id) {
    return Environ.api(Environ.cdnServer, '/data/$id');
  }

  static Widget _buildError({
    double placeholderSize = 100,
    String errorComment = '이미지 준비중',
  }) {
    return Center(
        child: Text(errorComment,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 172, 172, 172),
                fontSize: 16 * (placeholderSize / 100))));
  }

  static Widget image({
    Color placeholderColor = const Color.fromARGB(255, 192, 195, 210),
    double placeholderSize = 100,
    String errorComment = '이미지 준비중',
    BoxFit? fit,
    double? width,
    double? height,
    required String? id,
  }) {
    if (id == null || id.isEmpty) {
      return _buildError(
          placeholderSize: placeholderSize, errorComment: errorComment);
    }

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
        errorWidget: (_, __, ___) => _buildError(
            errorComment: errorComment, placeholderSize: placeholderSize));
  }
}
