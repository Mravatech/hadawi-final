
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntities{

  const UserModel({
    required super.email,
    required super.uId,
    required super.name,
    required super.phone,
    required super.brithDate,
    required super.gender,
    required super.block
  });

  factory UserModel.fromFire(Map<String,dynamic> json){
    return UserModel(
      email: json['email'],
      uId: json['uId'],
      name: json['name'],
      phone: json['phone'],
      brithDate: json['brithDate'],
      gender: json['gender'],
      block: json['block'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'email':email,
      'uId':uId,
      'name':name,
      'phone':phone,
      'gender':gender,
      'brithDate':brithDate,
      'block':block
    };
  }


}