import 'package:flutter/material.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';

class ToDoView extends StatefulWidget {
  final List<MyPlantData> myPlants;

  const ToDoView({
    super.key,
    required this.myPlants,
  });

  @override
  State createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
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
                    )),
          ]
      ],
    );
  }
}

class ToDoItem extends StatelessWidget {
  final MyPlantData myPlant;
  final ScheduleToDoItme schedule;

  const ToDoItem({
    super.key,
    required this.myPlant,
    required this.schedule,
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
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: buildText(),
            ),
            const Text(
              '보기',
              style: TextStyle(
                  color: Color(0xFF53CE86), fontWeight: FontWeight.w600),
            )
          ],
        ));
  }
}
