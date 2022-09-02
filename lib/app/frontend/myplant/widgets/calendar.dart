import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/gradient.dart';

class WidthCalendar extends StatefulWidget {
  final List<MyPlantData> myPlants;
  final bool showSlider;
  final double scale;

  const WidthCalendar(
      {super.key,
      required this.myPlants,
      this.showSlider = true,
      this.scale = 1});

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
            if (widget.showSlider)
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
                      scale: widget.scale)
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
  final double scale;

  const WidthCalendarItem(
      {super.key,
      required this.date,
      required this.today,
      required this.myPlants,
      this.scale = 1});

  Iterable<String> get _todo sync* {
    for (var item in myPlants) {
      if (item.schedule != null) {
        final todo = item.schedule?.todo(date);
        if (todo != null) yield* todo;
      }
    }
  }

  bool isDone(String schedule) {
    return myPlants
        .any((item) => item.schedule?.isDone(schedule, date) == true);
  }

  @override
  Widget build(BuildContext context) {
    final todos = _todo;
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    List<Color> dots = [];

    for (var todo in todos) {
      Color? keyColor;

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

      if (keyColor != null) {
        dots.add(keyColor);
      }
    }

    final circleWidth = 32 * scale;
    return Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(weekDateFormat(date),
                  style: TextStyle(
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
            Container(
              width: circleWidth,
              height: circleWidth,
              decoration: BoxDecoration(
                  gradient: isToday ? primaryGradient : null,
                  shape: BoxShape.circle),
              child: Center(
                child: Text(date.day.toString(),
                    style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.bold,
                        color: isToday ? Colors.white : Colors.black45)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < max(3, dots.length); i++)
                    Container(
                        width: 5 * scale,
                        height: 5 * scale,
                        margin: const EdgeInsets.only(left: 1, right: 1),
                        decoration: BoxDecoration(
                          color: i < dots.length ? dots[i] : Colors.white,
                          shape: i < dots.length
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                        ))
                ],
              ),
            ),
          ],
        ));
  }
}
