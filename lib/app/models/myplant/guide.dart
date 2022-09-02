class GuideEquipmentData {
  final String icon;
  final String equipmentName;
  final String description;

  GuideEquipmentData({
    required this.icon,
    required this.equipmentName,
    required this.description,
  });

  factory GuideEquipmentData.fromJson(Map<String, dynamic> json) =>
      GuideEquipmentData(
        icon: json["icon"],
        equipmentName: json["equipment_name"],
        description: json["description"],
      );
}

class GuideData {
  final String action;
  final String image;
  final String description;
  final List<GuideEquipmentData> equipments;

  GuideData({
    required this.action,
    required this.image,
    required this.description,
    required this.equipments,
  });

  factory GuideData.fromJson(Map<String, dynamic> json) => GuideData(
        action: json["action"],
        image: json["image"],
        description: json["description"],
        equipments: List<GuideEquipmentData>.from(
            json["equipment"].map((x) => GuideEquipmentData.fromJson(x))),
      );
}
