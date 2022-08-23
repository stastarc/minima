import 'package:flutter/material.dart';
import 'package:minima/app/models/field.dart';
import 'package:minima/app/models/lens/credit.dart';
import 'package:minima/app/models/market/product.dart';

class AnalysisDiseaseReportData {
  final bool healthy;
  final String name;
  final double score;
  final Rect? rect;

  AnalysisDiseaseReportData({
    required this.healthy,
    required this.name,
    required this.score,
    required this.rect,
  });

  factory AnalysisDiseaseReportData.fromJson(Map<String, dynamic> json) {
    final rect = json['rect'];

    return AnalysisDiseaseReportData(
        healthy: json['healthy'] as bool,
        name: json['name'] as String,
        score: json['score'] as double,
        rect: json['rect'] == null
            ? null
            : Rect.fromLTWH(rect[0].toDouble(), rect[1].toDouble(),
                rect[2].toDouble(), rect[3].toDouble()));
  }
}

class AnalysisReportData {
  final double score;
  final String name;
  final String area;
  final Rect rect;
  final AnalysisDiseaseReportData? disease;

  AnalysisReportData({
    required this.score,
    required this.name,
    required this.area,
    required this.rect,
    required this.disease,
  });

  factory AnalysisReportData.fromJson(Map<String, dynamic> json) {
    final rect = json['rect'];
    return AnalysisReportData(
        score: json['score'] as double,
        name: json['name'] as String,
        area: json['area'] as String,
        rect: Rect.fromLTWH(rect[0].toDouble(), rect[1].toDouble(),
            rect[2].toDouble(), rect[3].toDouble()),
        disease: json['disease'] == null
            ? null
            : AnalysisDiseaseReportData.fromJson(
                json['disease'] as Map<String, dynamic>));
  }
}

class AnalysisPlantHarmfulnessData {
  final String type;
  final String level;
  final String comment;

  AnalysisPlantHarmfulnessData({
    required this.type,
    required this.level,
    required this.comment,
  });

  factory AnalysisPlantHarmfulnessData.fromJson(Map<String, dynamic> json) {
    return AnalysisPlantHarmfulnessData(
      type: json['type'] as String,
      level: json['level'] as String,
      comment: json['comment'] as String,
    );
  }
}

class AnalysisPlantManagementData {
  final String type;
  final String comment;
  final List<LinkedField> linked;

  AnalysisPlantManagementData({
    required this.type,
    required this.comment,
    required this.linked,
  });

  factory AnalysisPlantManagementData.fromJson(Map<String, dynamic> json) {
    return AnalysisPlantManagementData(
      type: json['type'] as String,
      comment: json['comment'] as String,
      linked: json['linked'] != null
          ? (json['linked'] as List<dynamic>)
              .map((e) => LinkedField.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class AnalysisPlantContent {
  final String version;
  final List<AnalysisPlantHarmfulnessData> harmfulness;
  final List<AnalysisPlantManagementData> management;

  AnalysisPlantContent({
    required this.version,
    required this.harmfulness,
    required this.management,
  });

  factory AnalysisPlantContent.fromJson(Map<String, dynamic> json) {
    return AnalysisPlantContent(
      version: json['\$ver'] as String,
      harmfulness: (json['harmfulness'] as List<dynamic>)
          .map((e) =>
              AnalysisPlantHarmfulnessData.fromJson(e as Map<String, dynamic>))
          .toList(),
      management: (json['management'] as List<dynamic>)
          .map((e) =>
              AnalysisPlantManagementData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AnalysisReleventPlantData {
  final int plantId;
  final LoclizedField name;
  final String image;

  AnalysisReleventPlantData({
    required this.plantId,
    required this.name,
    required this.image,
  });

  factory AnalysisReleventPlantData.fromJson(Map<String, dynamic> json) {
    return AnalysisReleventPlantData(
      plantId: json['id'] as int,
      name: LoclizedField.fromJson(json['names'] as Map<String, dynamic>),
      image: json['image'] as String,
    );
  }
}

class AnalysisPlantInfo {
  final int plantId;
  final LoclizedField name;
  final List<String> images;
  final String description;
  final String moreDescription;
  final AnalysisPlantContent content;
  final List<AnalysisReleventPlantData> releventPlants;
  final DateTime updatedAt;

  AnalysisPlantInfo({
    required this.plantId,
    required this.name,
    required this.images,
    required this.description,
    required this.moreDescription,
    required this.content,
    required this.releventPlants,
    required this.updatedAt,
  });

  factory AnalysisPlantInfo.fromJson(Map<String, dynamic> json) {
    return AnalysisPlantInfo(
      plantId: json['id'] as int,
      name: LoclizedField.fromJson(json['names'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
      moreDescription: json['more_description'] as String,
      content: AnalysisPlantContent.fromJson(
          json['content'] as Map<String, dynamic>),
      releventPlants: (json['relevent_plants'] as List<dynamic>)
          .map((e) =>
              AnalysisReleventPlantData.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class AnalysisDiseaseData {
  final int diseaseId;
  final int plantId;
  final String name;
  final List<String> images;
  final String content;
  final String moreContent;
  final DateTime updatedAt;

  AnalysisDiseaseData({
    required this.diseaseId,
    required this.plantId,
    required this.name,
    required this.images,
    required this.content,
    required this.moreContent,
    required this.updatedAt,
  });

  factory AnalysisDiseaseData.fromJson(Map<String, dynamic> json) {
    return AnalysisDiseaseData(
      diseaseId: json['id'] as int,
      plantId: json['plant_id'] as int,
      name: json['name'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      content: json['content'] as String,
      moreContent: json['more_content'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class AnalysisPlantData {
  final AnalysisReportData? report;
  final AnalysisPlantInfo? plant;
  final AnalysisDiseaseData? disease;

  AnalysisPlantData({
    required this.report,
    required this.plant,
    required this.disease,
  });

  bool get hasPlant => report != null && plant != null;
  bool get hasDisease => report != null && disease != null;

  factory AnalysisPlantData.fromJson(Map<String, dynamic> json) {
    return AnalysisPlantData(
      report: json['report'] != null
          ? AnalysisReportData.fromJson(json['report'] as Map<String, dynamic>)
          : null,
      plant: json['plant'] != null
          ? AnalysisPlantInfo.fromJson(json['plant'] as Map<String, dynamic>)
          : null,
      disease: json['disease'] != null
          ? AnalysisDiseaseData.fromJson(
              json['disease'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AnalysisResultData {
  final AnalysisPlantData info;
  final AnalysisCreditData credit;
  final List<Product> relatedProducts;

  AnalysisResultData({
    required this.info,
    required this.credit,
    required this.relatedProducts,
  });

  factory AnalysisResultData.fromJson(Map<String, dynamic> json) {
    return AnalysisResultData(
      info: AnalysisPlantData.fromJson(json['info'] as Map<String, dynamic>),
      credit:
          AnalysisCreditData.fromJson(json['credit'] as Map<String, dynamic>),
      relatedProducts: (json['related_products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
