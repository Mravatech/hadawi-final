
import 'package:hadawi_app/featuers/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntities{

  const UserModel({
    required super.email,
    required super.uId,
    required super.name,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.brithDate,
    required super.gender,
    required super.city,
    required super.token,
    required super.date,
    required super.password,
    required super.private,
    required super.block
  });

  factory UserModel.fromFire(Map<String,dynamic> json){
    return UserModel(
      email: json['email'],
      uId: json['uId'],
      name: json['name'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      brithDate: json['brithDate'],
      gender: json['gender'],
      city: json['city'],
      token: json['token'],
      private: json['private'],
      password: json['password']??'',
      date: json['date'],
      block: json['block'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'email':email,
      'uId':uId,
      'name':name,
      'firstName':firstName,
      'lastName':lastName,
      'phone':phone,
      'gender':gender,
      'city':city,
      'date':date,
      'private':private,
      'token':token,
      'brithDate':brithDate,
      'block':block
    };
  }


}