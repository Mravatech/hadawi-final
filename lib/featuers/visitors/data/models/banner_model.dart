class BannerModel {
  final String id;
  final String image;
  final String url;

  BannerModel({
    required this.id,
    required this.image,
    required this.url,
  });

  factory BannerModel.fromMap(Map<String, dynamic> json) => BannerModel(
    id: json["id"]??'',
    image: json["image"]??'',
    url: json["url"]??'',
  );

  Map<String, dynamic> toMap() => {
    "id": id??'',
    "image": image??'',
    "url": url??'',
  };
}