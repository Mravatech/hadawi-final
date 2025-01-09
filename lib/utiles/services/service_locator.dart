import 'package:get_it/get_it.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/featuers/auth/data/repository/auth_repository_implement.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_use_cases.dart';


final getIt = GetIt.instance;

class ServiceLocator {

  void init() {

    getIt.registerLazySingleton<BaseAuthDataSource>(() => AuthDataSourceImplement());

    getIt.registerLazySingleton<AuthBaseRepository>(()=> AuthRepositoryImplement());

    getIt.registerLazySingleton(()=> LoginUseCases(authBaseRepository: getIt()));

  }

}