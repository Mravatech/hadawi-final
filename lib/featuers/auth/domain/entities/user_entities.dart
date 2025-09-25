import 'package:equatable/equatable.dart';

class UserEntities extends Equatable{

  final String email;
  final String uId;
  final String name;
  final String firstName;
  final String lastName;
  final String phone;
  final String brithDate;
  final String password;
  final String gender;
  final String city;
  final String date;
  final String token;
  final bool block;
  final bool private;


  const UserEntities({
    required this.email,
    required this.uId,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.brithDate,
    required this.gender,
     this.password='',
    required this.date,
    required this.city,
    required this.token,
    required this.block,
    this.private=false,
});

  @override

  List<Object?> get props => [email, uId, name, firstName, lastName, phone, brithDate, gender, city, block,date,token, password, private];

}