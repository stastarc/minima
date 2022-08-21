import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/frontend/myplant/widgets/diary.comment.dart';
import 'package:minima/app/models/myplant/diary.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/datepicker.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:minima/shared/widgets/image_list.dart';
import 'package:minima/shared/widgets/open_image.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:collection/collection.dart';
import 'package:toast/toast.dart';

class DiaryEditPage extends StatefulWidget {
  final MyPlantData plant;
  final DiaryData diary;
  final VoidCallback onSave;

  const DiaryEditPage({
    super.key,
    required this.plant,
    required this.diary,
    required this.onSave,
  });

  @override
  State createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  final _imagePageController = PageController();
  final commentController = TextEditingController();
  final List<dynamic> _images = [];
  late DiaryData diary;
  late DateTime _date;
  BackendError? _error;
  bool _isLoading = false;

  void ensureImages() {
    _images.sort((a, b) =>
        a is String ? (b is String ? 0 : -10) : (b is String ? 10 : 0));
  }

  void setImage(int index, dynamic image) {
    if (index < _images.length) {
      _images[index] = image;
    } else {
      _images.add(image);
    }
    ensureImages();
    setState(() {
      _imagePageController.jumpToPage(_images.indexOf(image));
    });
  }

  void onDateChanged(DateTime date) async {
    if (date == _date && _error == null) return;
    if (_isLoading) return;
    _isLoading = true;
    _date = date;
    _error = null;
    setState(() {});

    try {
      final res = await MyPlant.instance.getDiary(widget.plant.id, date);
      if (res != null) {
        diary = res;
        if (diary.comment.isEmpty) {
          diary.comment = getComment(widget.plant.name, []);
        }
        init();
      } else {
        _error = BackendError.unknown();
      }
    } catch (e) {
      _error = BackendError.fromException(e);
    }

    _isLoading = false;
    setState(() {});
  }

  void retry() {
    onDateChanged(_date);
  }

  void onSetImage(int index) {
    showOpenImageMenu(context, (img) {
      if (img == null) return;
      setImage(index, img);
    });
  }

  void onDeleteImage(int index) {
    _images.removeAt(index);
    setState(() {});
  }

  void onDone() {
    final keeps = _images.whereType<String>().toList();
    final images = _images
        .where((e) => e is! String)
        .map((e) => e.path as String)
        .toList();

    futureWaitDialog<bool>(
      context,
      title: '다이어리 저장',
      message: '다이어리를 저장하고있어요.',
      future: (() async {
        ToastContext().init(context);
        final res = await MyPlant.instance.setDiary(
            widget.plant.id, _date, commentController.text,
            keepImages: keeps, images: images);
        return res != null;
      })(),
      onDone: (f) {
        Toast.show(f ? '다이어리를 저장했어요.' : '다이어리를 저장하지 못했어요.',
            duration: Toast.lengthLong);
        Navigator.pop(context);
        widget.onSave();
      },
      onError: (e) {
        Toast.show('다이어리를 저장하지 못했어요.\n$e', duration: Toast.lengthLong);
        Navigator.pop(context);
      },
    );
  }

  void init() {
    _images.clear();
    _images.addAll(diary.images);
    _date = diary.date;
    ensureImages();
    commentController.text = diary.comment;
  }

  @override
  void initState() {
    super.initState();
    diary = widget.diary;
    init();
  }

  Widget imageBuilder(BuildContext _, int index) {
    final image = index < _images.length ? _images[index] : null;
    Widget child;

    if (image is String) {
      child = CDN.image(id: image, fit: BoxFit.cover);
    } else if (image is File) {
      child = Image.file(image, fit: BoxFit.cover);
    } else {
      child = const Icon(
        Icons.add,
        size: 32,
        color: Colors.white,
      );
    }
    return ClipButton(
        height: 320,
        borderRadius: BorderRadius.zero,
        onPressed: () => onSetImage(index),
        backgroundColor: const Color(0x4E000000),
        overlay: image != null
            ? Align(
                alignment: Alignment.topRight,
                child: ClipOval(
                    child: IconButton(
                        onPressed: () => onDeleteImage(index),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 32,
                          color: Colors.white,
                        ))),
              )
            : null,
        child: child);
  }

  List<Widget> buildBody() {
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PageListView(
            controller: _imagePageController,
            height: 320,
            itemBuilder: imageBuilder,
            itemCount: 5),
      ),
      const SizedBox(height: 12),
      PrimaryTextField(
        controller: commentController,
        title: '내용',
        minLines: 10,
        maxLines: 10,
        maxLength: 450,
        keyboardType: TextInputType.multiline,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        title: '다이어리',
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(children: [
              Expanded(
                  child: ListView(
                children: [
                  DatePickerField(
                      title: null,
                      selectedDate: _date,
                      maxDate: DateTime.now(),
                      onDateSelected: onDateChanged),
                  const SizedBox(height: 16),
                  if (_error == null)
                    if (_isLoading) buildBodySkeleton() else ...buildBody()
                  else
                    RetryButton(
                      onPressed: retry,
                      error: _error!,
                      text: '다이어리를 가져오지 못했습니다.',
                    )
                ],
              )),
              const SizedBox(height: 12),
              PrimaryButton(
                  borderRadius: 14,
                  grey: _isLoading,
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
            ])));
  }

  Widget buildBodySkeleton() {
    return Skeleton(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SkeletonBox(
          height: 320,
          width: double.infinity,
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: SkeletonText(
            wordLengths: [28, 25, 16],
            fontSize: 14,
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }
}
