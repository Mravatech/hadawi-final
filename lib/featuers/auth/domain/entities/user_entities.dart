import 'package:equatable/equatable.dart';

class UserEntities extends Equatable{

  final String email;
  final String uId;
  final String name;
  final String phone;
  final String brithDate;
  final String gender;
  final bool block;


  const UserEntities({
    required this.email,
    required this.uId,
    required this.name,
    required this.phone,
    required this.brithDate,
    required this.gender,
    required this.block
});

  @override

  List<Object?> get props => [email, uId, name, phone, brithDate, gender, block];

}