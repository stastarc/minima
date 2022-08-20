import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/frontend/myplant/pages/myplant.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/dialog.dart';
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
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 4,
      runSpacing: 16,
      children: [
        for (final myPlant in widget.myPlants)
          MyPlantItem(
            myPlant: myPlant,
            onRefresh: widget.onRefresh,
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
  final VoidCallback onRefresh;

  const MyPlantItem({
    super.key,
    required this.myPlant,
    required this.onRefresh,
  });

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
          )));
    }

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
