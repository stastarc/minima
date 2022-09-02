import 'dart:io';

import 'package:http/http.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/models/myplant/diary.dart';
import 'package:minima/app/models/myplant/guide.dart';
import 'package:minima/app/models/myplant/info.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';
import 'package:minima/shared/number_format.dart';

import '../environ.dart';

part 'myplant.api.dart';

class MyPlant {
  static MyPlant? _instance;
  static MyPlant get instance => _instance ??= MyPlant();

  // List<MyPlantData>? _myPlants;

  // Future<List<MyPlantData>> getCachedMyPlants() async {
  //   var myPlants = (_myPlants ??= await getMyPlants(includeSchedule: true))!;
  //   if (myPlants.isNotEmpty) {
  //     if (DateTime.now().difference(myPlants.first.schedule!.today) >
  //         const Duration(days: 1)) {
  //       _myPlants = await getMyPlants(includeSchedule: true);
  //     }
  //   }
  //   return myPlants;
  // }
}
