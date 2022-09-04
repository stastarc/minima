import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/frontend/myplant/pages/myplant.dart';
import 'package:minima/app/frontend/myplant/pages/myplant_edit.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:toast/toast.dart';

import '../pages/add_plant.dart';

part 'plant.menu.dart';

class MyPlantView extends StatefulWidget {
  final List<MyPlantData> myPlants;
  final VoidCallback onRefresh;

  const MyPlantView({
    super.key,
    required this.myPlants,
    required this.onRefresh,
  });

  @override
  State createState() => _MyPlantViewState();
}

class _MyPlantViewState extends State<MyPlantView> {
  void onAdd() {
    showMyPlantAddMenuSheet(context, widget.onRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final myPlant in widget.myPlants)
          MyPlantItem(
            myPlant: myPlant,
            onRefresh: widget.onRefresh,
          ),
        MyPlantItem.buildItem(
            Container(
              width: 80,
              height: 80,
              color: const Color(0x1F000000),
              child: const Center(
                  child: Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              )),
            ),
            '새 식물 추가하기',
            '새로운 식물을 추가해보아요.',
            null,
            onAdd,
            null)
      ],
    );
  }
}

class MyPlantItem extends StatelessWidget {
  final MyPlantData myPlant;
  final VoidCallback onRefresh;

  const MyPlantItem({
    super.key,
    required this.myPlant,
    required this.onRefresh,
  });

  String getString(ScheduleToDoItme todo) {
    return '${deliveryDateFormat(todo.last)} ${todo.localizedName}를 완료했어요.';
  }

  @override
  Widget build(BuildContext context) {
    onMenu() {
      showMyPlantMenuSheet(context, onRefresh: onRefresh);
    }

    onPressed() {
      Navigator.push(
          context,
          slideRTL(MyPlantItemPage(
            myPlant: myPlant,
            onRefresh: onRefresh,
          )));
    }

    return buildItem(
        CDN.image(
            id: myPlant.image, width: 100, height: 100, fit: BoxFit.cover),
        myPlant.name,
        myPlant.plantName,
        getString(myPlant.schedule!.items
            .reduce((a, b) => a.last.isAfter(b.last) ? a : b)),
        onPressed,
        onMenu);
  }

  static Widget buildItem(Widget icon, String name, String? type, String? more,
      VoidCallback onPressed, VoidCallback? onMore) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ClipOval(
              child: icon,
            ),
            const SizedBox(width: 18),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                if (type != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
                if (more != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    more,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ]
              ],
            )),
            if (onMore != null)
              GestureDetector(
                  onTap: onMore,
                  child: const Icon(Icons.more_vert,
                      color: Colors.black87, size: 22))
          ],
        ),
      ),
    );
  }
}

class MyPlantViewSkeleton extends StatelessWidget {
  const MyPlantViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 14,
      runSpacing: 12,
      children: [
        for (var i = 0; i < 4; i++)
          Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const SkeletonBox(
                  width: 100,
                  height: 100,
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 18),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonText(
                      wordLengths: [12],
                      fontSize: 17,
                    ),
                    SizedBox(height: 4),
                    SkeletonText(
                      wordLengths: [8],
                      fontSize: 14,
                    ),
                  ],
                )),
              ],
            ),
          )
      ],
    );
  }
}
