class PlantInfoData {
  final int id;
  final String name;
  final String image;

  const PlantInfoData({
    required this.id,
    required this.name,
    required this.image,
  });

  PlantInfoData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        image = json['image'] as String;
}
