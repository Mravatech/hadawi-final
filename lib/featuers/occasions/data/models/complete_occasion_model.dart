class CompleteOccasionModel {

  String occasionId;
  String imagesUrl;
  String imagesUrl2;
  String title;
  String des;
  String status;
  double finalPrice;

  CompleteOccasionModel({
    required this.occasionId,
    required this.imagesUrl,
    required this.imagesUrl2,
    required this.title,
    required this.des,
    required this.status,
    required this.finalPrice,
  });

  factory CompleteOccasionModel.fromJson(Map<String, dynamic> json) {
    return CompleteOccasionModel(
      occasionId: json['occasionId'],
      imagesUrl: json['imagesUrl'] ,
      status: json['status'] ??'',
      title: json['title'] ??'',
      imagesUrl2: json['imagesUrl2'] ??'',
      des: json['des'] ??'',
      finalPrice: json['finalPrice'].runtimeType == int
          ? (json['finalPrice'] as int).toDouble()
          : json['finalPrice'] as double,
    );
  }


}