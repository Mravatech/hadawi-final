import 'package:get_it/get_it.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/featuers/auth/data/repository/auth_repository_implement.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/check_user_login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/get_user_info_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/google_auth_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_with_phone_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/logout.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/register_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/save_data_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/verifiy_code_use_cases.dart';


final getIt = GetIt.instance;

class ServiceLocator {

  void init() {

    getIt.registerLazySingleton<BaseAuthDataSource>(() => AuthDataSourceImplement());

    getIt.registerLazySingleton<AuthBaseRepository>(()=> AuthRepositoryImplement(baseAuthDataSource: getIt()));

    getIt.registerLazySingleton(()=> LoginUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> RegisterUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> SaveDataUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> LogoutUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> GoogleAuthUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> LoginWithPhoneUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> VerifiyCodeUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> CheckUserLoginUseCases(authBaseRepository: getIt()));
    getIt.registerLazySingleton(()=> GetUserInfoUseCases(authBaseRepository: getIt()));


  }

}