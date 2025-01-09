import 'package:equatable/equatable.dart';

class UserEntities extends Equatable{

  final String email;
  final String uId;
  final String name;
  final String phone;


  const UserEntities({
    required this.email,
    required this.uId,
    required this.name,
    required this.phone
});

  @override

  List<Object?> get props => [email, uId, name, phone];

}