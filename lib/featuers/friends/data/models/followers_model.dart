import 'package:hadawi_app/featuers/friends/domain/entities/follower_entities.dart';

class FollowersModel extends FollowerEntities {

  const FollowersModel({
    required super.userId,
    required super.userName,
    required super.image,
    required super.follow
  });

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
      userId: json['uId'],
      userName: json['name'],
      image: json['image'],
      follow: json['follow']
    );
  }


  Map<String, dynamic> toMap() => {
    'uId': userId,
    'name': userName,
    'image': image,
    'follow': follow,
  };



}