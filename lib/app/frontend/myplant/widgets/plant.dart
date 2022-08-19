import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';

import '../pages/add_plant.dart';

part 'plant.menu.dart';

class MyPlantView extends StatefulWidget {
  final List<MyPlantData> myPlants;

  const MyPlantView({
    super.key,
    required this.myPlants,
  });

  @override
  State createState() => _MyPlantViewState();
}

class _MyPlantViewState extends State<MyPlantView> {
  void onAdd() {
    showMyPlantAddMenuSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 4,
      runSpacing: 16,
      children: [
        for (final myPlant in widget.myPlants)
          MyPlantItem(
            myPlant: myPlant,
          ),
        ClipButton(
          width: 160,
          height: 160,
          onPressed: onAdd,
          child: Container(
            color: const Color(0x14000000),
            child: const Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        if (widget.myPlants.length % 2 == 0)
          const SizedBox(
            width: 160,
            height: 160,
          ),
      ],
    );
  }
}

class MyPlantItem extends StatelessWidget {
  final MyPlantData myPlant;

  const MyPlantItem({
    super.key,
    required this.myPlant,
  });

  @override
  Widget build(BuildContext context) {
    onMenu() {
      showMyPlantMenuSheet(context);
    }

    onPressed() {}

    return Column(children: [
      ClipButton(
        width: 160,
        height: 160,
        onPressed: onPressed,
        overlay: Align(
            alignment: Alignment.topRight,
            child: PrimaryButton(
                width: 0,
                onPressed: onMenu,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.more_vert,
                    color: Colors.white, size: 22))),
        child: CDN.image(id: myPlant.image, fit: BoxFit.cover),
      ),
      const SizedBox(height: 3),
      Text(
        myPlant.name,
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    ]);
  }
}
