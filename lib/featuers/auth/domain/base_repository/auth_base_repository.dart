abstract class AuthBaseRepository {

  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});
  Future<void> logout();

}