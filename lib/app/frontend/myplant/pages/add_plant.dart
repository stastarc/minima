import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/frontend/myplant/widgets/search.dart';
import 'package:minima/app/models/myplant/info.dart';
import 'package:minima/shared/utils/name_generator.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/datepicker.dart';
import 'package:minima/shared/widgets/expandable.dart';
import 'package:minima/shared/widgets/open_image.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:toast/toast.dart';
import 'package:tuple/tuple.dart';

import 'add_plant.register.dart';

part 'add_plant.page.dart';

class MyPlantAddPage extends StatefulWidget {
  final VoidCallback onAdd;

  const MyPlantAddPage({
    super.key,
    required this.onAdd,
  });

  @override
  State createState() => _MyPlantAddPageState();
}

class _MyPlantAddPageState extends State<MyPlantAddPage> {
  final nameField = TextEditingController();
  String? name;

  late List<Tuple2<bool Function(), Widget Function()>> _pages;
  int page = 0;
  File? image;
  PlantInfoData? plant;
  Map<String, DateTime> dates = {};
  bool isDone = false;

  void onNext() {
    if (page < pages.length - 1) {
      final pg = pages[page];
      if (!pg.item1()) return;
      setState(() {
        page++;
      });
    } else {
      if (!isDone) return;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = pages;
  }

  void onDone() {
    setState(() {
      isDone = true;
      widget.onAdd();
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final isLast = page == pages.length - 1;
    return PageWidget(
        hideClose: isLast,
        title: '식물 등록하기',
        child: Column(
          children: [
            Expanded(child: (kDebugMode ? pages : _pages)[page].item2()),
            if (page != 0)
              Padding(
                  padding: const EdgeInsets.all(14),
                  child: PrimaryButton(
                      borderRadius: 14,
                      grey: isLast ? !isDone : false,
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      onPressed: onNext,
                      child: Text(
                        isLast ? '완료' : '다음',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))),
          ],
        ));
  }
}
