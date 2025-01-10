import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {

  AuthCubit() : super(AuthInitialState());

}