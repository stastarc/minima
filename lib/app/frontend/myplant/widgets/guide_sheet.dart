import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/models/myplant/guide.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/future_builder_widget.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:toast/toast.dart';
import 'package:tuple/tuple.dart';

class GuideSheet extends StatefulWidget {
  final MyPlantData plant;
  final ScheduleToDoItme todo;
  final VoidCallback onDone;

  const GuideSheet({
    super.key,
    required this.plant,
    required this.todo,
    required this.onDone,
  });

  @override
  State createState() => _GuideSheetState();
}

class _GuideSheetState extends State<GuideSheet> {
  void onDone() async {
    futureWaitDialog<bool>(context, title: '스케줄', message: '스케줄을 정리하고있어요.',
        future: (() async {
      ToastContext().init(context);
      final todo = await MyPlant.instance
          .scheduleDone(widget.plant.id, widget.todo.name);
      return todo != null;
    })(), onDone: (f) {
      Toast.show(f ? '스케줄을 완료했어요.' : '스케줄을 저장하지 못했어요.',
          duration: Toast.lengthLong);
      Navigator.pop(context);
      widget.onDone();
    }, onError: (e) {
      Toast.show('스케줄을 저장하지 못했어요.\n$e', duration: Toast.lengthLong);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget<GuideData>(
      futureBuilder: () async =>
          (await MyPlant.instance.getGuide(widget.todo.name, widget.plant.id))!,
      completedBuilder: (guide) => Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(32, 22, 32, 0),
                    width: double.infinity,
                    height: 220,
                    child: CDN.image(id: guide.image, fit: BoxFit.cover),
                  ),
                  const ColumnHeader(
                    title: '튜토리얼',
                    width: 110,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 22),
                    child: AutoSizeText(guide.description,
                        style: const TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                  const ColumnHeader(
                    title: '준비물',
                    width: 100,
                  ),
                  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var equipment in guide.equipments)
                            Container(
                              width: 110,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (equipment.icon.indexOf('!') == 0)
                                      CDN.image(
                                          id: equipment.icon.substring(1),
                                          width: 46,
                                          height: 46,
                                          fit: BoxFit.cover)
                                    else
                                      Text(equipment.icon,
                                          style: const TextStyle(
                                              fontSize: 42,
                                              fontFamily: 'SegoeUIEmoji')),
                                    const SizedBox(height: 8),
                                    Text(equipment.equipmentName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(equipment.description,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500))
                                  ]),
                            )
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
                      child: PrimaryButton(
                          borderRadius: 14,
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          onPressed: onDone,
                          child: const Text(
                            '완료했어요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )))
                ],
              ),
              Column(
                children: [
                  const Text('가이드',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(widget.todo.localizedName,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF3D3D3D))),
                ],
              ),
            ],
          )
        ],
      ),
      loading: Skeleton(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(children: const [
              SkeletonText(
                wordLengths: [6],
                fontSize: 24,
              ),
              SkeletonText(wordLengths: [12], fontSize: 14),
            ]),
          ),
          const SkeletonBox(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
          ),
          const ColumnHeaderSkeleton(width: 110),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 22),
            child: SkeletonText(
              wordLengths: [28, 26],
              fontSize: 15,
              lineHeight: .4,
            ),
          ),
          const ColumnHeaderSkeleton(width: 110),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SkeletonBox(
                    width: 110,
                    height: 135,
                  ),
                  SkeletonBox(
                    width: 110,
                    height: 135,
                  ),
                  SkeletonBox(
                    width: 110,
                    height: 135,
                  ),
                ],
              )),
          const Padding(
              padding: EdgeInsets.fromLTRB(16, 26, 16, 16),
              child: SkeletonBox(
                radius: 14,
                width: double.infinity,
                height: 45,
              ))
        ],
      )),
    );
  }
}

class ColumnHeader extends StatelessWidget {
  final String title;
  final double? width;
  final AlignmentGeometry? alignment;

  const ColumnHeader({
    super.key,
    required this.title,
    this.width,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.fromLTRB(22, 6, 16, 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF55CF94),
            Color(0xFF53CE78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }
}

class ColumnHeaderSkeleton extends StatelessWidget {
  final double? width;

  const ColumnHeaderSkeleton({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 17 + 6 + 6,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
    );
  }
}
