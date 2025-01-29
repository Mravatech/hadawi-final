import 'package:equatable/equatable.dart';

class FollowerEntities extends Equatable {

  final String userId;
  final String userName;
  final String image;
  final bool follow;

 const FollowerEntities({
    required this.userId,
    required this.userName,
    required this.image,
    required this.follow,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    userName,
    image,
    follow
  ];


}