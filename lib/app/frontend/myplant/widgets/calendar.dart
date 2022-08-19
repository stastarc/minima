import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/button.dart';

class WidthCalendar extends StatefulWidget {
  final List<MyPlantData> myPlants;

  const WidthCalendar({super.key, required this.myPlants});

  @override
  State createState() => _WidthCalendarState();
}

class _WidthCalendarState extends State<WidthCalendar> {
  late List<MyPlantData> myPlants;
  int weekOffset = 0;

  @override
  void initState() {
    super.initState();
    myPlants = widget.myPlants;
  }

  void onSlide(double delta) {
    if (delta == 0) return;
    setState(() {
      weekOffset += delta > 0 ? -1 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekday = today.day + 1 - today.weekday + (weekOffset * 7);
    final offsetDate = DateTime(today.year, today.month, weekday);

    return GestureDetector(
        onHorizontalDragEnd: (details) {
          onSlide(details.primaryVelocity ?? 0);
        },
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF3D3D3D), size: 22),
                    onPressed: () => onSlide(1)),
                Text(
                  monthDateFormat(offsetDate),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D),
                      decoration: TextDecoration.none),
                ),
                PrimaryButton(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF3D3D3D), size: 22),
                    onPressed: () => onSlide(-1))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < 7; i++)
                  WidthCalendarItem(
                    date: offsetDate.add(Duration(days: i)),
                    today: today,
                    myPlants: myPlants,
                  )
              ],
            )
          ]),
        ));
  }
}

class WidthCalendarItem extends StatelessWidget {
  final DateTime date;
  final DateTime today;
  final List<MyPlantData> myPlants;
  final double? width;
  final double? height;

  const WidthCalendarItem({
    super.key,
    required this.date,
    required this.today,
    required this.myPlants,
    this.width,
    this.height = 59,
  });

  String? get _todo {
    for (var item in myPlants) {
      if (item.schedule != null) {
        final todo = item.schedule?.todo(date);
        if (todo?.isNotEmpty == true) return todo!.first;
      }
    }
    return null;
  }

  bool isDone(String schedule) {
    return myPlants
        .any((item) => item.schedule?.isDone(schedule, date) == true);
  }

  @override
  Widget build(BuildContext context) {
    final todo = _todo;
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    dynamic backgroundColor, foregroundColor;

    if (todo != null) {
      final isDone = this.isDone(todo);
      Color keyColor = Colors.black;

      switch (todo) {
        case "water":
          keyColor = const Color(0xFF397CE0);
          break;
        case "fertilize":
          keyColor = const Color(0xFFBD814A);
          break;
        case "prune":
          keyColor = const Color(0xFFF06292);
          break;
        case "harvest":
          keyColor = Colors.teal;
          break;
        default:
      }

      if (isDone) {
        backgroundColor = keyColor;
        foregroundColor = Colors.white;
      } else {
        foregroundColor = keyColor;
      }
    } else {
      foregroundColor = Colors.black45;
    }

    if (isToday) {
      backgroundColor ??= foregroundColor;
      foregroundColor = Colors.white;
    }

    final circleWidth = 32 * (32 / min(width ?? 32, height ?? 32));
    return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: isToday
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(circleWidth / 2),
              )
            : null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(weekDateFormat(date),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : Colors.black54)),
            ),
            Container(
              width: circleWidth,
              height: circleWidth,
              decoration: isToday
                  ? null
                  : BoxDecoration(
                      color: backgroundColor, shape: BoxShape.circle),
              child: Center(
                child: Text(date.day.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: foregroundColor)),
              ),
            )
          ],
        ));
  }
}
