class AnalysisModel {
  final int closeOccasions;
  final int openOccasions;
  final int paymentAmount;

  AnalysisModel({
    required this.paymentAmount,
    required this.closeOccasions,
    required this.openOccasions
  });

  factory AnalysisModel.fromMap(Map<String, dynamic> json) => AnalysisModel(
    paymentAmount: json["paymentAmount"] ?? 0,
    closeOccasions: json["closeOccasions"] ?? 0,
    openOccasions: json["openOccasions"] ?? 0
  );

  Map<String, dynamic> toMap() => {
    "paymentAmount": paymentAmount,
    "closeOccasions": closeOccasions,
    "openOccasions": openOccasions
  };
}