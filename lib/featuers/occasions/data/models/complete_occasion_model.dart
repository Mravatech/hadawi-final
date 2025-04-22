class CompleteOccasionModel {

  String occasionId;
  String imagesUrl;
  String title;
  String status;
  double finalPrice;

  CompleteOccasionModel({
    required this.occasionId,
    required this.imagesUrl,
    required this.title,
    required this.status,
    required this.finalPrice,
  });

  factory CompleteOccasionModel.fromJson(Map<String, dynamic> json) {
    return CompleteOccasionModel(
      occasionId: json['occasionId'],
      imagesUrl: json['imagesUrl'] ,
      status: json['status'] ??'',
      title: json['title']??'' ,
      finalPrice: json['finalPrice'].runtimeType == int
          ? (json['finalPrice'] as int).toDouble()
          : json['finalPrice'] as double,
    );
  }


}