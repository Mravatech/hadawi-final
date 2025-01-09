import 'package:equatable/equatable.dart';

class Faliure extends Equatable{

  final String message;

  const Faliure({required this.message});

  @override
  List<Object?> get props => [message];

}

class ServerFaliure extends Faliure{

  const ServerFaliure({required super.message});
}