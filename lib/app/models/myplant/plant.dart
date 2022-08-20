import 'package:minima/app/models/myplant/schedule.dart';

class MyPlantRegisterData {
  final int id;
  final String name;
  final String image;
  final int plantId;
  final ScheduleInitData? schedule;

  MyPlantRegisterData({
    required this.id,
    required this.name,
    required this.image,
    required this.plantId,
    required this.schedule,
  });

  MyPlantRegisterData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        image = json['image'] as String,
        plantId = json['plant_id'] as int,
        schedule = json['schedule'] == null
            ? null
            : ScheduleInitData.fromJson(
                json['schedule'] as Map<String, dynamic>);
}

class MyPlantData {
  final int id;
  final String name;
  final String image;
  final int plantId;
  final String plantName;
  final ScheduleToDoData? schedule;

  const MyPlantData({
    required this.id,
    required this.name,
    required this.image,
    required this.plantId,
    required this.plantName,
    required this.schedule,
  });

  MyPlantData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        image = json['image'] as String,
        plantId = json['plant_id'] as int,
        plantName = json['plant_name'] as String,
        schedule = json['schedule'] == null
            ? null
            : ScheduleToDoData.fromJson(
                json['schedule'] as Map<String, dynamic>);
}
