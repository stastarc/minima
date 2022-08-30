class AnalysisCreditData {
  int credit;

  AnalysisCreditData({
    required this.credit,
  });

  factory AnalysisCreditData.fromJson(Map<String, dynamic> json) {
    return AnalysisCreditData(
      credit: (json['credit'] ?? json['current']) as int,
    );
  }
}
