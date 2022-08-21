import 'package:flutter/material.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/frontend/myplant/pages/diary_edit.dart';
import 'package:minima/app/frontend/myplant/widgets/diary.comment.dart';
import 'package:minima/app/frontend/myplant/widgets/diary_item.dart';
import 'package:minima/app/models/myplant/diary.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/retry.dart';

class DiaryView extends StatefulWidget {
  final MyPlantData plant;
  final void Function(void Function() onArrived) onBuilder;

  const DiaryView({
    super.key,
    required this.plant,
    required this.onBuilder,
  });

  @override
  State createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  final today = DateTime.now();
  List<DiaryData> diaries = [];
  BackendError? error;
  int currentPage = 0, pageCount = -1;
  bool loading = false;

  void ensureTodayCard() {
    if (diaries.any((e) => e.date.difference(today).inDays < 1)) return;
    diaries.insert(
        0,
        DiaryData(
            date: today,
            comment: getComment(
                widget.plant.name, widget.plant.schedule?.todo(today) ?? []),
            images: []));
  }

  void onArrived() async {
    if (loading || (pageCount != -1 && currentPage >= pageCount)) return;
    loading = true;
    setState(() {});

    try {
      final result = (await MyPlant.instance
          .getDiaries(widget.plant.id, offset: currentPage))!;
      pageCount = result.pageCount;
      diaries.addAll(result.diaries);
      ensureTodayCard();
      currentPage++;
    } catch (e) {
      error = BackendError.fromException(e);
    }

    loading = false;
    setState(() {});
  }

  void onReset() {
    pageCount = -1;
    currentPage = 0;
    diaries = [];
    onArrived();
  }

  @override
  void initState() {
    super.initState();
    widget.onBuilder(onArrived);
    onArrived();
  }

  void onEdit(DiaryData diary) {
    Navigator.push(
        context,
        slideRTL(DiaryEditPage(
          diary: diary,
          plant: widget.plant,
          onSave: onReset,
        )));
  }

  Widget buildItem(BuildContext c, int i) {
    if (i < diaries.length) {
      final diary = diaries[i];
      return DiaryItem(
        diary: diary,
        today: today,
        isEnd: i == diaries.length - 1,
        onEdit: () => onEdit(diary),
      );
    } else if (loading) {
      return DiariesSkeleton(hasFirst: diaries.isEmpty);
    } else if (error != null) {
      return RetryButton(
        onPressed: onArrived,
        error: error!,
        text: '다이어리를 불러오지 못했습니다.',
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: diaries.length + (loading ? 1 : 0),
      itemBuilder: buildItem,
    );
  }
}
