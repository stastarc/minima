import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/frontend/myplant/widgets/calendar.dart';
import 'package:minima/app/frontend/myplant/widgets/diary.dart';
import 'package:minima/app/frontend/myplant/widgets/todo.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/widgets/infinity_scroll.dart';
import 'package:minima/shared/widgets/page.dart';

class MyPlantItemPage extends StatefulWidget {
  final MyPlantData myPlant;
  final VoidCallback onRefresh;

  const MyPlantItemPage({
    super.key,
    required this.myPlant,
    required this.onRefresh,
  });

  @override
  State createState() => _MyPlantItemPageState();
}

class _MyPlantItemPageState extends State<MyPlantItemPage> {
  InfinityScrollController? scroll;
  bool isInBody = false;
  void Function()? _onArrived;

  void onArrived() {
    if (_onArrived == null) return;
    _onArrived!();
  }

  void onArrivedAt(double scroll) {
    if (scroll >= 250) {
      if (!isInBody) {
        isInBody = true;
        setState(() {});
      }
    } else {
      if (isInBody) {
        isInBody = false;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void onDiaryBuilder(void Function() onArrived) {
    _onArrived = onArrived;
  }

  Widget buildBody() {
    return ListView(
      controller: scroll ??= InfinityScrollController(
          onArrived: onArrived,
          onArrivedAt: onArrivedAt,
          arrivedAtList: [0, 250],
          proximityPixel: MediaQuery.of(context).size.height * 2),
      children: [
        const SizedBox(height: 250 - 12 - 2),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            const SizedBox(height: 26),
            Text(
              widget.myPlant.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.myPlant.plantName,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            WidthCalendar(
              myPlants: [widget.myPlant],
              showSlider: false,
              scale: .8,
            ),
            const SizedBox(height: 8),
            ToDoView(myPlants: [widget.myPlant], onRefresh: widget.onRefresh),
            DiaryView(plant: widget.myPlant, onBuilder: onDiaryBuilder)
          ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        fullScreen: true,
        titleColor: isInBody ? Colors.grey[800]! : Colors.white,
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: CDN.image(id: widget.myPlant.image, fit: BoxFit.cover),
              ),
              Positioned(
                  top: 0, bottom: 0, left: 0, right: 0, child: buildBody())
            ])));
  }
}
