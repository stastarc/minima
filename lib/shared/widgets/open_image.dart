import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';

void showOpenImageMenu(
    BuildContext context, void Function(File? image) callback,
    {List<BottomMenuItem>? items}) {
  void onPickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    callback(image != null ? File(image.path) : null);
  }

  showBottomMenuSheet(context, [
    ...?items,
    BottomMenuItem(
        title: '사진 찍기', onPressed: () => onPickImage(ImageSource.camera)),
    BottomMenuItem(
        title: '사진 선택', onPressed: () => onPickImage(ImageSource.gallery)),
  ]);
}
