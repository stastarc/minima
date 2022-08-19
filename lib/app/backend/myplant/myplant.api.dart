part of 'myplant.dart';

extension MyPlantCache on MyPlant {
  Future<MyPlantData?> getMyPlant(int id, {bool includeSchedule = true}) async {
    return await Environ.privateGetResopnse(Environ.myplantServer,
        '/myplant/plants/$id', (json) => MyPlantData.fromJson(json),
        query: {'include_schedule': includeSchedule});
  }

  Future<List<MyPlantData>?> getMyPlants({bool includeSchedule = true}) async {
    return await Environ.privateGetResopnse(
        Environ.myplantServer,
        '/myplant/plants',
        (json) => (json as List<dynamic>)
            .map((e) => MyPlantData.fromJson(e))
            .toList(),
        query: {'include_schedule': includeSchedule});
  }

  Future<MyPlantRegisterData?> registerMyPlant(String name, String imagePath,
      int plantId, Map<String, DateTime> schedules) async {
    var req = MultipartRequest(
        "post",
        await Environ.privateApi(
            Environ.myplantServer, '/myplant/plants/register'));
    req.fields['name'] = name;
    req.fields['image'] = imagePath;
    req.fields['plant_id'] = plantId.toString();
    req.fields['last_schedule'] = lastScheduleToString(schedules);
    req.files.add(await MultipartFile.fromPath('image', imagePath));
    return await Environ.tryResponseParse(
        await req.send(), (json) => MyPlantRegisterData.fromJson(json));
  }

  Future<List<PlantInfoData>?> searchPlants(String query,
      {int offset = 0}) async {
    return await Environ.privateGetResopnse(
        Environ.myplantServer,
        '/info/plants',
        (json) => (json as List<dynamic>)
            .map((e) => PlantInfoData.fromJson(e))
            .toList(),
        query: {'query': query.padRight(2), 'offset': offset});
  }
}
