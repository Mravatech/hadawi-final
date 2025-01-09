
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';

class AuthRepositoryImplement extends AuthBaseRepository {

  @override
  Future<void> login({required String email, required String password}) {

    throw UnimplementedError();
  }

  @override
  Future<void> logout() {

    throw UnimplementedError();
  }

  @override
  Future<void> register({required String email, required String password}) {

    throw UnimplementedError();
  }

}