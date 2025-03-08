class BannerModel {
  final String id;
  final String image;

  BannerModel({
    required this.id,
    required this.image,
  });

  factory BannerModel.fromMap(Map<String, dynamic> json) => BannerModel(
    id: json["id"]??'',
    image: json["image"]??'',
  );

  Map<String, dynamic> toMap() => {
    "id": id??'',
    "image": image??'',
  };
}