import 'package:get_it/get_it.dart';
import 'package:hadawi_app/featuers/auth/data/data_source/auth_data_source.dart';
import 'package:hadawi_app/featuers/auth/data/repository/auth_repository_implement.dart';
import 'package:hadawi_app/featuers/auth/domain/base_repository/auth_base_repository.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/check_user_login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/delete_user_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/get_user_info_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/google_auth_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/login_with_phone_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/logout.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/register_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/save_data_use_cases.dart';
import 'package:hadawi_app/featuers/auth/domain/use_cases/verifiy_code_use_cases.dart';
import 'package:hadawi_app/featuers/edit_personal_info/data/data_source/edit_profile_data_source.dart';
import 'package:hadawi_app/featuers/edit_personal_info/data/repo_implement/edit_profile_repo_implemnt.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/repo/edit_profile_repo.dart';
import 'package:hadawi_app/featuers/edit_personal_info/domain/use_cases/edit_profile_use_cases.dart';
import 'package:hadawi_app/featuers/friends/data/data_source/friends_data_source.dart';
import 'package:hadawi_app/featuers/friends/data/repo_implement/friends_repo_implement.dart';
import 'package:hadawi_app/featuers/friends/domain/repo/friends_repo.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/accept_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_followers_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/get_following_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/reject_follow_request_use_cases.dart';
import 'package:hadawi_app/featuers/friends/domain/use_cases/send_follow_request_use_cases.dart';


final getIt = GetIt.instance;

class ServiceLocator {

  void init() {

    /// Auth Layer
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
    getIt.registerLazySingleton(()=> DeleteUserUseCases(authBaseRepository: getIt()));

    /// Edit Profile Layer
    getIt.registerLazySingleton(()=> EditProfileUseCases(editProfileRepo: getIt()));
    getIt.registerLazySingleton<EditProfileDataSource>(()=> EditProfileDataSourceImplement(baseAuthDataSource: getIt()));
    getIt.registerLazySingleton<EditProfileRepo>(()=> EditProfileRepoImplement(editProfileDataSource:  getIt()));

    /// Friends Layer
    getIt.registerLazySingleton(()=> SendFollowRequestUseCases(friendsRepo: getIt()));
    getIt.registerLazySingleton(()=> AcceptFollowRequestUseCases(friendsRepo: getIt()));
    getIt.registerLazySingleton(()=> RejectFollowRequestUseCases(friendsRepo: getIt()));
    getIt.registerLazySingleton(()=> GetFollowersUseCases(friendsRepo: getIt()));
    getIt.registerLazySingleton(()=> GetFollowingUseCases(friendsRepo: getIt()));
    getIt.registerLazySingleton<FriendsDataSource>(()=> FriendsDataSourceImplement());
    getIt.registerLazySingleton<FriendsRepo>(()=> FriendsRepoImplement(friendsDataSource:  getIt()));


  }

}