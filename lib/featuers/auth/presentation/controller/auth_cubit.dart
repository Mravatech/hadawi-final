import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_states.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/error_handling/exceptions/exceptions.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(
    this.loginUseCases,
    this.registerUseCases,
    this.saveDataUseCases,
    this.logoutUseCases,
    this.googleAuthUseCases,
    this.loginWithPhoneUseCases,
    this.verifiyCodeUseCases,
    this.getUserInfoUseCases,
    this.checkUserLoginUseCases,
    this.deleteUserUseCases,
  ) : super(AuthInitialState());

  LoginUseCases loginUseCases;
  RegisterUseCases registerUseCases;
  SaveDataUseCases saveDataUseCases;
  LogoutUseCases logoutUseCases;
  GoogleAuthUseCases googleAuthUseCases;
  LoginWithPhoneUseCases loginWithPhoneUseCases;
  VerifiyCodeUseCases verifiyCodeUseCases;
  GetUserInfoUseCases getUserInfoUseCases;
  CheckUserLoginUseCases checkUserLoginUseCases;
  DeleteUserUseCases deleteUserUseCases;

  String dropdownCity = "";
  List<String> saudiCities = [
    // منطقة الرياض
    "الرياض", "الدرعية", "الخرج", "الدوادمي", "المجمعة", "الزلفي", "شقراء",
    "وادي الدواسر", "الأفلاج", "عفيف", "حوطة بني تميم", "السليل", "ثادق",
    "حريملاء", "رماح", "المزاحمية", "ضرماء", "مرات",

    // منطقة مكة المكرمة
    "مكة المكرمة", "جدة", "الطائف", "رابغ", "الليث", "القنفذة", "الخرمة",
    "الكامل", "خليص", "الجموم", "رنية", "تربة",

    // منطقة المدينة المنورة
    "المدينة المنورة", "ينبع", "العلا", "بدر", "الحناكية", "خيبر", "المهد",

    // المنطقة الشرقية
    "الدمام", "الخبر", "الظهران", "الجبيل", "القطيف", "الأحساء", "رأس تنورة",
    "الخفجي", "النعيرية", "حفر الباطن", "قرية العليا", "بقيق",

    // منطقة القصيم
    "بريدة", "عنيزة", "الرس", "المذنب", "البكيرية", "البدائع", "الأسياح",
    "النبهانية", "عيون الجواء", "رياض الخبراء", "الشماسية",

    // منطقة عسير
    "أبها", "خميس مشيط", "بيشة", "محايل عسير", "النماص", "رجال ألمع",
    "سراة عبيدة", "ظهران الجنوب", "تثليث", "أحد رفيدة", "المجاردة", "البرك",

    // منطقة حائل
    "حائل", "بقعاء", "الشنان", "الغزالة", "الحائط", "السليمي", "سميراء",

    // منطقة تبوك
    "تبوك", "الوجه", "ضباء", "أملج", "حقل", "البدع",

    // منطقة نجران
    "نجران", "شرورة", "حبونا", "يدمة", "بدر الجنوب", "ثار", "خباش",

    // منطقة جازان
    "جازان", "صبيا", "أبو عريش", "صامطة", "فرسان", "العارضة", "الداير بني مالك",
    "أحد المسارحة", "بيش", "العيدابي", "الدرب", "الحرث",

    // منطقة الباحة
    "الباحة", "بلجرشي", "المندق", "المخواة", "العقيق", "قلوة",

    // منطقة الجوف
    "سكاكا", "القريات", "دومة الجندل",

    // منطقة الحدود الشمالية
    "عرعر", "رفحاء", "طريف"
  ];

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController brithDateController = TextEditingController();

  Future<void> login(
      {required String email,
      required String password,
      required context,
      bool isMobileLogin = false}) async {
    emit(UserLoginLoadingState());
    try {
      final result = await loginUseCases.login(
          email: email, password: password, context: context, isMobileLogin: isMobileLogin);
      result.fold((l) {
        emit(UserLoginErrorState(message: l.message));
      }, (r) {
        emit(UserLoginSuccessState());
      });
    } catch (e) {
      emit(UserLoginErrorState(message: 'تم حذف الحساب'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String phone,
    required String name,
    required context,
    required String brithDate,
    required String gender,
    required String city,
  }) async {
    emit(UserRegisterLoadingState());
    final result = await registerUseCases.register(
        email: email,
        password: password,
        brithDate: brithDate,
        gender: gender,
        name: name,
        context: context,
        phone: phone,
        city: city);
    result.fold((l) {
      debugPrint('Register Error**********${l.message}');
      emit(UserRegisterErrorState(message: l.message));
    }, (r) {
      debugPrint('Register Success********** - profile completion required');
      emit(ProfileCompletionRequiredState());
    });
  }

  String otpCode = '';
  String generateRandomCode({int length = 6}) {
    const String chars =
        '0123456789';
    final Random random = Random();
    final String code =
    List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
    otpCode = code;
    debugPrint("Generated OTP Code: $code");
    debugPrint("Stored otpCode: $otpCode");
    emit(GenerateCodeSuccessState());
    return code;
  }

  Future<void> sendOtp({required String phone,}) async {
    emit(SendOtpLoadingState());
    try {
      debugPrint("Sending OTP to phone: $phone");
      debugPrint("Current otpCode: $otpCode");
      
      if (phone.isEmpty) {
        emit(SendOtpErrorState(message: 'Phone number is required'));
        return;
      }
      if (otpCode.isEmpty || !RegExp(r'^\d+$').hasMatch(otpCode)) {
        debugPrint("Invalid OTP code: $otpCode");
        emit(SendOtpErrorState(message: 'Invalid OTP code'));
        return;
      }

      final parsedOtp = int.parse(otpCode);
      debugPrint("Sending OTP: $parsedOtp to phone: $phone");
      final result = await registerUseCases.sendOtp(phone: phone, otp: parsedOtp, );

      result.fold((l) {
        debugPrint("Send OTP error: ${l.message}");
        emit(SendOtpErrorState(message: l.message));
      }, (r) {
        debugPrint("OTP sent successfully!");
        customToast(title: 'تم ارسال كود التحقق', color: ColorManager.primaryBlue);
        emit(SendOtpSuccessState());
      });
    } catch (e) {
      debugPrint('Unexpected error in sendOtp: $e');
      emit(SendOtpErrorState(message: 'Unexpected error: $e'));
    }
  }
  void verifyOtp({required int otp}) {
    emit(VerifiyOtpCodeLoadingState());
    debugPrint("Verifying OTP: $otp against stored code: $otpCode");
    if (otpCode.isEmpty) {
      emit(VerifiyOtpCodeErrorState(message: 'No OTP code found. Please request a new code.'));
      return;
    }
    if (otp == int.parse(otpCode)) {
      debugPrint("Manual OTP verification successful! Now proceeding with Firebase phone auth...");
      emit(VerifiyOtpCodeSuccessState());
    } else {
      debugPrint("OTP verification failed: $otp != ${int.parse(otpCode)}");
      emit(VerifiyOtpCodeErrorState(message: 'The verification code you entered is incorrect. Please try again.'));
    }
  }

  // Method to handle authentication after manual OTP verification
  // Uses custom authentication system with Firestore users collection
  Future<void> authenticateAfterManualOtp({
    required String phone,
    required String email,
    required String password,
    required BuildContext context,
    required bool isLogin,
  }) async {
    emit(VerifiyOtpCodeLoadingState());
    debugPrint("Manual OTP verified, now using custom authentication for: '$phone'");
    debugPrint("Email parameter: '$email'");
    debugPrint("Password parameter: '$password'");
    debugPrint("Is login: $isLogin");
    
    try {
      if (isLogin) {
        // For login, validate user with custom authentication
        await _customAuthenticateUser(phone, email, password, context);
      } else {
        // For registration, create new user with custom authentication
        await _customRegisterUser(phone, email, password, context);
      }
    } catch (e) {
      debugPrint("Custom authentication after manual OTP failed: $e");
      emit(VerifiyOtpCodeErrorState(message: 'Authentication failed: $e'));
    }
  }

  // Custom authentication system - validate user against Firestore users collection
  // Supports both phone and email login (cross-credential authentication)
  Future<void> _customAuthenticateUser(String phone, String email, String password, BuildContext context) async {
    try {
      debugPrint("Custom authentication: Validating user with phone: '$phone', email: '$email'");
      
      QuerySnapshot userQuery;
      String searchField;
      
      // Determine if we're searching by phone or email
      if (phone.isNotEmpty) {
        // Search by phone number
        userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();
        searchField = 'phone';
      } else if (email.isNotEmpty) {
        // Search by email
        userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        searchField = 'email';
      } else {
        debugPrint("Custom auth: No phone or email provided");
        emit(VerifiyOtpCodeErrorState(message: 'Please provide phone number or email.'));
        return;
      }
      
      if (userQuery.docs.isEmpty) {
        debugPrint("Custom auth: User not found in Firestore by $searchField, auto-registering...");
        // Auto-register the user since they've verified their phone number via OTP
        await _customRegisterUser(phone, email, password, context);
        return;
      }
      
      final userDoc = userQuery.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;
      
      // Validate password if provided
      if (password.isNotEmpty && userData['password'] != password) {
        debugPrint("Custom auth: Invalid password");
        emit(VerifiyOtpCodeErrorState(message: 'Invalid password.'));
        return;
      }
      
      // Generate custom authentication token
      final customToken = _generateCustomAuthToken(userDoc.id, phone.isNotEmpty ? phone : email);
      debugPrint("Custom auth: Generated token for user: ${userDoc.id}");
      
      // Store authentication data
      await _storeCustomAuthData(userDoc.id, userData, customToken);
      
      debugPrint("Custom authentication successful");
      
      // Check if profile is complete after storing data
      if (isProfileComplete()) {
        emit(UserLoginSuccessState());
      } else {
        emit(ProfileCompletionRequiredState());
      }
    } catch (e) {
      debugPrint("Custom authentication error: $e");
      emit(VerifiyOtpCodeErrorState(message: 'Authentication failed: $e'));
    }
  }

  // Custom registration system - create new user in Firestore users collection
  // Checks for existing users by both email and phone to prevent duplicates
  Future<void> _customRegisterUser(String phone, String email, String password, BuildContext context) async {
    try {
      debugPrint("Custom registration: Creating user with phone: '$phone', email: '$email'");
      
      // Check if user already exists by phone (if phone is provided)
      if (phone.isNotEmpty) {
        final phoneQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();
        
        if (phoneQuery.docs.isNotEmpty) {
          debugPrint("Custom registration: User already exists with this phone, authenticating instead");
          await _customAuthenticateUser(phone, email, password, context);
          return;
        }
      }
      
      // Check if user already exists by email (if email is provided)
      if (email.isNotEmpty) {
        final emailQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        
        if (emailQuery.docs.isNotEmpty) {
          debugPrint("Custom registration: User already exists with this email, authenticating instead");
          await _customAuthenticateUser(phone, email, password, context);
          return;
        }
      }
      
      // Generate unique user ID
      final userId = FirebaseFirestore.instance.collection('users').doc().id;
      debugPrint("Custom registration: Creating new user with ID: $userId");
      
      // Create user document in Firestore
      await saveUserData(
        uId: userId,
        email: email,
        phone: phone,
        name: '',
        brithDate: '',
        gender: '',
        password: password,
        city: '',
      );
      
      // Generate custom authentication token
      final customToken = _generateCustomAuthToken(userId, phone.isNotEmpty ? phone : email);
      debugPrint("Custom registration: Generated token for new user: $userId");
      
      // Store authentication data
      await _storeCustomAuthData(userId, {
        'name': '',
        'email': email,
        'phone': phone,
        'gender': '',
        'brithDate': '',
        'city': '',
      }, customToken);
      
      debugPrint("Custom registration successful - profile completion required");
      emit(ProfileCompletionRequiredState());
    } catch (e) {
      debugPrint("Custom registration error: $e");
      emit(VerifiyOtpCodeErrorState(message: 'Registration failed: $e'));
    }
  }

  // Generate custom authentication token
  String _generateCustomAuthToken(String userId, String phone) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    // Create a custom token that includes user ID, phone, and timestamp
    final token = '${userId}_${phone}_${timestamp}_${random}_custom_auth';
    debugPrint("Generated custom auth token: $token");
    return token;
  }

  // Store custom authentication data
  Future<void> _storeCustomAuthData(String userId, Map<String, dynamic> userData, String customToken) async {
    // Store user data in secure storage
    await UserDataFromStorage.setUid(userId);
    await UserDataFromStorage.setUserName(userData['name'] ?? '');
    await UserDataFromStorage.setEmail(userData['email'] ?? '');
    await UserDataFromStorage.setPhoneNumber(userData['phone'] ?? '');
    await UserDataFromStorage.setGender(userData['gender'] ?? '');
    await UserDataFromStorage.setBrithDate(userData['brithDate'] ?? '');
    await UserDataFromStorage.setUserIsGuest(false);
    
    // Store custom authentication token
    await UserDataFromStorage.setAuthToken(customToken);
    
    debugPrint("Custom auth data stored successfully");
  }
  Future<void> saveUserData(
      {required String uId,
      required String email,
      required String phone,
      required String name,
      required String brithDate,
      required String gender,
      required String password,
      required String city,
      String firstName = '',
      String lastName = ''}) async {
    emit(UserSaveDataLoadingState());
    final result = await saveDataUseCases.saveUserData(
        uId: uId,
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        password: password,
        gender: gender,
        city: city,
        firstName: firstName,
        lastName: lastName);
    result.fold((l) {
      emit(UserSaveDataErrorState(message: l.message));
    }, (r) {
      emit(UserSaveDataSuccessState());
    });
  }

  Future<void> logout() async {
    emit(UserLogoutLoadingState());
    final result = await logoutUseCases.logout();
    result.fold((l) {
      emit(UserLogoutErrorState(message: l.message));
    }, (r) {
      emit(UserLogoutSuccessState());
    });
  }

  Future<void> deleteUser() async {
    emit(DeleteUserLoadingState());
    final result = await deleteUserUseCases.deleteUser(
        uId: UserDataFromStorage.uIdFromStorage
    );
    result.fold((l) {
      emit(DeleteUserErrorState(message: l.message));
    }, (r) {
      emit(DeleteUserSuccessState());
    });
  }

  void setBrithDate({required DateTime brithDateValue}) {
    brithDateController.text = DateFormat('yyyy-MM-dd').format(brithDateValue);
    emit(SetBrithDayValueState());
  }

  Future<void> signInWithGoogle(
      {required String brithDate,
      required String gender,
      required BuildContext context,
      required String city}) async {
    emit(SignInWithSocialMediaLoadingState());
    try {
      final result = await googleAuthUseCases.loginWithGoogle(
          brithDate: brithDate, gender: gender, city: city,context: context);
      result.fold((l) {
        emit(SignInWithSocialMediaErrorState(message: l.message));
      }, (r) {
        customToast(title: 'تم التسجيل', color: ColorManager.primaryBlue);
        
        // Check if profile is complete after Google authentication
        if (isProfileComplete()) {
          emit(SignInWithSocialMediaSuccessState());
        } else {
          emit(ProfileCompletionRequiredState());
        }
      });
    } catch (e) {
      emit(SignInWithSocialMediaErrorState(message: ''));
    }
  }

  String genderValue = 'Male';

  void changeGenderValue(String? value) {
    genderValue = value!;
    print(genderValue);
    emit(SelectGenderTypeState());
  }

  bool isLoading = false;

  Future<void> loginWithPhone(
      {required String phone,
      required String email,
      required String name,
      required String brithDate,
      required String gender,
      required String city,
      required bool resendCode,
      required bool isLogin,
      required BuildContext context}) async {
    isLoading = true;
    emit(LoginWithPhoneLoadingState());
    final result = await loginWithPhoneUseCases.call(
        context: context,
        phone: phone,
        email: email,
        name: name,
        resendCode: resendCode,
        isLogin: isLogin,
        brithDate: brithDate,
        gender: gender,
        city: city);
    result.fold((l) {
      isLoading = false;
      emit(LoginWithPhoneErrorState(message: l.message));
    }, (r) async {
      isLoading = false;
      emit(LoginWithPhoneSuccessState());
    });
  }

  Future<void> verifiyOtpCode({
    required String email,
    required String phone,
    required String name,
    required String brithDate,
    required String gender,
    required String city,
    required String verificationId,
    required bool isLogin,
    required String verifyOtpPinPut,
  }) async {
    emit(VerifiyOtpCodeLoadingState());

    final result = await verifiyCodeUseCases.call(
        email: email,
        phone: phone,
        name: name,
        brithDate: brithDate,
        gender: gender,
        city: city,
        isLogin: isLogin,
        verificationId: verificationId,
        verifyOtpPinPut: verifyOtpPinPut);

    result.fold((l) {
      emit(VerifiyOtpCodeErrorState(message: l.message));
    }, (r) {
      customToast(title: 'تم التحقق', color: ColorManager.primaryBlue);
      emit(VerifiyOtpCodeSuccessState());
    });
  }

  int second = 0;
  Timer? secondTimer;
  bool resendButton = false;

  resendOtpTimer() {
    second = 31;
    secondTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second > 0) {
        --second;
        emit(ResendCodeTimerState());
      } else {
        resendButton = true;
        second = 0;
        secondTimer!.cancel();
        emit(ResendCodeTimerFinishedState());
      }
    });
  }

  Future<void> getUserInfo({required String uId, required context}) async {
    emit(GetUserDataLoadingState());
    try {
      final result =
          await getUserInfoUseCases.getUserInfo(uId: uId, context: context);
      result.fold((l) => emit(GetUserDataErrorState(message: l.message)), (r) {
        emit(GetUserDataSuccessState());
      });
    } catch (e) {
      print('error in getUserInfo $e');
      emit(GetUserDataErrorState(message: 'تم حذف الحساب من قبل الاداره'));
    }
  }

  Future<void> checkUserLogin({required String phoneNumber}) async {
    emit(CheckUserLoadingState());
    final result =
        await checkUserLoginUseCases.checkUserLogin(phoneNumber: phoneNumber);
    result.fold((l) => emit(CheckUserErrorState(message: l.message)), (r) {
      emit(CheckUserSuccessState());
    });
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccessState());
    } catch (e) {
      debugPrint("error in reset password: $e");
      emit(ResetPasswordErrorState(message: e.toString()));
    }
  }

  Future<void> signInWithApple({required BuildContext context}) async {
    emit(SignInWithSocialMediaLoadingState());
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Extract firstName and lastName from Apple credential
      String firstName = credential.givenName ?? "";
      String lastName = credential.familyName ?? "";
      String userName = credential.givenName != null && credential.familyName != null
          ? '${credential.givenName} ${credential.familyName}'
          : userCredential.user?.displayName ?? "";

      // Handle potentially null email
      String userEmail = credential.email ?? userCredential.user?.email ?? "";

      try {
        // Use the same saveUserData method as Google login for consistency
        await saveDataUseCases.saveUserData(
          email: userEmail,
          phone: '',
          name: userName,
          uId: userCredential.user!.uid,
          brithDate: '',
          gender: '',
          city: '',
          password: '',
          firstName: firstName,
          lastName: lastName,
        );

        // Get user data to populate local storage
        await getUserInfoUseCases.getUserInfo(uId: userCredential.user!.uid, context: context);

        // Check if profile is complete after storing data
        if (isProfileComplete()) {
          emit(SignInWithSocialMediaSuccessState());
        } else {
          emit(ProfileCompletionRequiredState());
        }
      } on FirebaseException catch (e) {
        emit(SignInWithSocialMediaErrorState(message: e.toString()));
        throw FireStoreException(firebaseException: e);
      }
    } catch (e) {
      emit(SignInWithSocialMediaErrorState(message: e.toString()));
      debugPrint("Error signing in with Apple: $e");
    }
  }

  bool rememberMe = false;

  void rememberMeFunction(
      {value,
      required String emailController,
      required String passController}) {
    emit(RememberMeLoadingState());
    if (value != null) {
      rememberMe = value;
      UserDataFromStorage.setRememberMe(value);
      if (UserDataFromStorage.rememberMe == true) {
        UserDataFromStorage.setSavedEmail(emailController);
        UserDataFromStorage.setPassword(passController);
      }
    }
    emit(RememberMeSuccessState());
  }

  List<String> allCity = [];

  List<String> saudiCitiesList = [
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'المدينة المنورة',
    'الدمام',
    'الخبر',
    'الطائف',
    'أبها',
    'تبوك',
    'بريدة',
    'حائل',
    'نجران',
    'جيزان',
    'القطيف',
    'الظهران',
    'ينبع',
    'عرعر',
    'سكاكا',
    'الخرج',
    'الأحساء',
  ];

  Future<void> getAllCity()async{

    emit(GetAllCityLoadingState());
    try{
      var response = await FirebaseFirestore.instance.collection('city').get();
      response.docs.forEach((element) {
        allCity.add(element.data()['name']);
      });

      emit(GetAllCitySuccessState());
    }catch(e){
      debugPrint('error in get all city $e');
      emit(GetAllCityErrorState());
    }

  }

  Future<void> launchWhatsApp({required String phoneNumber, required String message})
  async {
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  // Check if user profile is complete (only essential fields: name, email, phone)
  bool isProfileComplete() {
    final userName = UserDataFromStorage.userNameFromStorage;
    final userEmail = UserDataFromStorage.emailFromStorage;
    final userPhone = UserDataFromStorage.phoneNumberFromStorage;

    // Check if essential fields are filled (name, email, phone number)
    return userName.isNotEmpty &&
           userEmail.isNotEmpty &&
           userPhone.isNotEmpty;
  }

}
