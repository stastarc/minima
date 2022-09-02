import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:minima/shared/widgets/open_image.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:toast/toast.dart';

class MyPlantEditPage extends StatefulWidget {
  final MyPlantData myPlant;
  final VoidCallback onRefresh;

  const MyPlantEditPage(
      {super.key, required this.myPlant, required this.onRefresh});

  @override
  State createState() => _MyPlantEditPageState();
}

class _MyPlantEditPageState extends State<MyPlantEditPage> {
  final _nameController = TextEditingController();
  File? image;

  void onSetImage() {
    showOpenImageMenu(context, (img) {
      if (img == null || !mounted) return;
      setState(() {
        image = img;
      });
    });
  }

  void onDone() {
    final name = _nameController.text.trim();

    if (widget.myPlant.name == name && image == null) {
      Navigator.pop(context);
      return;
    }

    if (name.length < 2) {
      Toast.show('별명은 2글자 이상이어야 합니다.');
      return;
    }

    futureWaitDialog<MyPlantData>(
      context,
      title: '이름/사진 변경',
      message: '이름/사진을 변경하고 있어요.',
      future: MyPlant.instance
          .updateMyPlant(widget.myPlant.id, name: name, image: image?.path),
      onDone: (f) {
        Toast.show('${f.name}의 정보를 수정했어요.', duration: Toast.lengthLong);
        Navigator.pop(context);
        widget.onRefresh();
      },
      onError: (e) {
        Toast.show('${widget.myPlant.name}의 정보를 수정하지 못했어요.\n$e',
            duration: Toast.lengthLong);
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.myPlant.name;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return PageWidget(
        title: '이름/사진 변경',
        child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      '사진',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF434343)),
                    ),
                    const SizedBox(height: 4),
                    ClipButton(
                        width: 340,
                        height: double.infinity,
                        onPressed: onSetImage,
                        backgroundColor: const Color(0xFF000000),
                        overlay: image != null
                            ? null
                            : const Center(
                                child: Icon(FluentIcons.edit_48_regular,
                                    size: 36, color: Colors.white),
                              ),
                        child: Opacity(
                          opacity: image != null ? 1 : .9,
                          child: image != null
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : CDN.image(
                                  id: widget.myPlant.image, fit: BoxFit.cover),
                        )),
                    const SizedBox(height: 16),
                    PrimaryTextField(
                      controller: _nameController,
                      title: '식물 별명',
                    ),
                  ],
                )),
                const SizedBox(height: 16),
                PrimaryButton(
                    borderRadius: 14,
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    onPressed: onDone,
                    child: const Text(
                      '저장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            )));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
