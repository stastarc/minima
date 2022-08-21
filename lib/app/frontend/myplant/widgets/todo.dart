import 'package:flutter/material.dart';
import 'package:minima/app/frontend/myplant/widgets/guide_sheet.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';

class ToDoView extends StatefulWidget {
  final List<MyPlantData> myPlants;
  final VoidCallback onRefresh;

  const ToDoView({
    super.key,
    required this.myPlants,
    required this.onRefresh,
  });

  @override
  State createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  void onDone() {
    setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final myPlant in widget.myPlants)
          if (myPlant.schedule != null) ...[
            for (final schedule in myPlant.schedule!.items)
              if (!schedule.done)
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    child: ToDoItem(
                      myPlant: myPlant,
                      schedule: schedule,
                      onDone: onDone,
                    )),
          ]
      ],
    );
  }
}

class ToDoItem extends StatelessWidget {
  final MyPlantData myPlant;
  final ScheduleToDoItme schedule;
  final VoidCallback onDone;

  const ToDoItem({
    super.key,
    required this.myPlant,
    required this.schedule,
    required this.onDone,
  });

  TextSpan buildText() {
    return TextSpan(
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        children: [
          TextSpan(text: '오늘은 ${myPlant.name}의 '),
          TextSpan(
            text: schedule.localizedName,
            style: const TextStyle(color: Color(0xFF53CE86)),
          ),
          const TextSpan(
            text: ' 일정이 있어요!',
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    void onViewGuide() {
      showSheet(context,
          padding: EdgeInsets.zero,
          child: GuideSheet(
            plant: myPlant,
            todo: schedule,
            onDone: () {
              myPlant.schedule?.items.remove(schedule);
              onDone();
            },
          ));
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: buildText(),
            ),
            GestureDetector(
                onTap: onViewGuide,
                child: const Text(
                  '보기',
                  style: TextStyle(
                      color: Color(0xFF53CE86), fontWeight: FontWeight.w600),
                ))
          ],
        ));
  }
}
