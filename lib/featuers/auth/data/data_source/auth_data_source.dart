abstract class BaseAuthDataSource {

  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});
  Future<void> logout();

}

class AuthDataSourceImplement extends BaseAuthDataSource {

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