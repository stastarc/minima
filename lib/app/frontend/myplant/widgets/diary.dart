import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/models/myplant/diary.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/widgets/image_list.dart';
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
  List<DiaryData> diaries = [];
  BackendError? error;
  int currentPage = 0, pageCount = -1;
  bool loading = false;

  void ensureTodayCard() {
    final today = DateTime.now();
    if (diaries.any((e) => e.date == today)) return;
    //TODO: 오늘 카드
    // diaries.insert(0, DiaryData(
    //   date: today,
    //   comment:
    // ));
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

  @override
  void initState() {
    super.initState();
    widget.onBuilder(onArrived);
    onArrived();
  }

  Widget buildItem(BuildContext c, int i) {
    if (i < diaries.length) {
      return DiaryItem(diary: diaries[i]);
    } else if (loading) {
      return const SkeletonBox(
        height: 100,
      );
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

class DiaryItem extends StatelessWidget {
  final DiaryData diary;

  const DiaryItem({
    super.key,
    required this.diary,
  });

  @override
  Widget build(BuildContext context) {
    return DiaryCard(
        date: diary.date,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageListView(
              images: diary.images,
              height: 320,
            ),
            const SizedBox(height: 12),
            SizedBox(
                child: AutoSizeText(
              diary.comment,
              maxLines: 5,
              maxFontSize: 16,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3D3D3D),
                fontWeight: FontWeight.w500,
              ),
            ))
          ],
        ));
  }
}

class DiaryCard extends StatelessWidget {
  final DateTime date;
  final Widget child;
  final double dateFontSize, datePosition, dotSize, lineWidth;
  final double? height;

  const DiaryCard(
      {super.key,
      required this.date,
      required this.child,
      this.dateFontSize = 15.0,
      this.datePosition = 34.0,
      this.lineWidth = 52.0,
      this.dotSize = 12.0,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
            padding: EdgeInsets.only(
                left: lineWidth,
                right: lineWidth / 2,
                top: datePosition + dotSize / 3 - dateFontSize / 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(longDateFormat(date),
                  style: TextStyle(fontSize: dateFontSize)),
              const SizedBox(height: 8),
              child
            ])),
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VerticalDivider(
                  thickness: 1,
                  width: lineWidth,
                  color: Colors.grey[300],
                ),
                Positioned(
                    top: datePosition,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: const BoxDecoration(
                          color: Color(0xFF55CF8F), shape: BoxShape.circle),
                    )),
              ],
            )),
      ],
    );
    // SizedBox(
    //   height: height,
    //   child: Stack(children: [
    //     Positioned(
    //         left: 48 + 6,
    //         top: datePosition + dotSize / 3 - dateFontSize / 2,
    //         child:
    //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //           Text(longDateFormat(date),
    //               style: TextStyle(fontSize: dateFontSize)),
    //           const SizedBox(height: 8),
    //           child
    //         ])),
    //     SizedBox(
    //       height: double.infinity,
    //       child: Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           VerticalDivider(
    //             thickness: 1,
    //             width: 48,
    //             color: Colors.grey[300],
    //           ),
    //           Positioned(
    //               top: datePosition,
    //               child: Container(
    //                 width: dotSize,
    //                 height: dotSize,
    //                 decoration: const BoxDecoration(
    //                     color: Color(0xFF55CF8F), shape: BoxShape.circle),
    //               )),
    //         ],
    //       ),
    //     ),
    //   ]),
    // );
  }
}
