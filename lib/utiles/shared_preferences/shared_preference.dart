import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class UserDataFromStorage {

  static late bool firstTime;
  static late bool userIsGuest;
  static late bool userIsLogin;
  static late bool themeIsDarkMode;
  static late bool onBoardingIsOpen;
  static late bool emailNotFound;
  static late bool gradeAdminFromStorage;
  static late bool attendenceAdminFromStorage;
  static late bool cameraFrontFromStorage;
  static late String userPhoneTypeFromStorage;
  static String languageCodeFromStorage = 'ar';
  static String languageNameFromStorage = "langArabic";

  static late String fullNameFromStorage;
  static late String adminUidFromStorage;
  static late String adminNameFromStorage;
  static late String emailFromStorage;
  static late String genderFromStorage;
  static late String brithDateFromStorage;
  static late String phoneNumberFromStorage;
  static late String countryFromStorage;
  static late String mainGroupFromStorage;
  static late String subGroupFromStorage;
  static late String userNameFromStorage;
  static late String organizationIdFromStorage;
  static late String folderNumFromStorage;
  static late String cityFromStorage;
  static late String uIdFromStorage;
  static late double balanceFromStorage;
  static late double cReductionFromStorage;
  static late double detectionFromStorage;
  static late double suspendedBalanceFromStorage;
  static late String macAddressFromStorage;
  static late String newOccasion;
  static late String giftType;
  static late String occasionDate;
  static late String moneyGiftAmount;
  static late String occasionName;
  static late String giftName;
  static late String link;
  static late String giftAmount;
  static late bool isForMe;

  static setFirstTimeApp(bool value) {
    firstTime = value;
    _setData();
  }


  static setOnBoardingOpened(bool value) {
    onBoardingIsOpen = value;
    _setData();
  }

  static setUserIsGuest(bool block) {
    userIsGuest = block;
    _setData();
  }

  static  setUserIsLogin(bool block) {
    userIsLogin = block;
    _setData();
  }

  static setThemeIsDarkMode(bool darkMode) {
    themeIsDarkMode = darkMode;
    _setData();
  }

  static setEmailNotFound(bool notFound) {
    emailNotFound = notFound;
    _setData();
  }

  static setCameraFront(bool value) {
    cameraFrontFromStorage = value;
    _setData();
  }

  static setGradeAdmin(bool gradeAdmin) {
    gradeAdminFromStorage = gradeAdmin;
    _setData();
  }

  static setAttendenceAdmin(bool attendenceAdmin) {
    attendenceAdminFromStorage = attendenceAdmin;
    _setData();
  }

  static setPhoneType(String value) {
    userPhoneTypeFromStorage = value;
    _setData();
  }

  static setAdminUid(String value) {
    adminUidFromStorage = value;
    _setData();
  }

  static setAdminName(String value) {
    adminNameFromStorage = value;
    _setData();
  }

  static setAppLanguageCode(String value) {
    languageCodeFromStorage = value;
    _setData();
  }

  static setMacAddress(String value) {
    macAddressFromStorage = value;
    _setData();
  }

  static setFullName(String value) {
    fullNameFromStorage = value;
    _setData();
  }

  static setEmail(String value) {
    emailFromStorage = value;
    _setData();
  }

  static setPhoneNumber(String value) {
    phoneNumberFromStorage = value;
    _setData();
  }

  static setCountry(String value) {
    countryFromStorage = value;
    _setData();
  }

  static setMainGroup(String value) {
    mainGroupFromStorage = value;
    _setData();
  }

  static setSubGroup(String value) {
    subGroupFromStorage = value;
    _setData();
  }

  static setUserName(String value) {
    userNameFromStorage = value;
    _setData();
  }

  static setGender(String value) {
    genderFromStorage = value;
    _setData();
  }

  static setBrithDate(String value) {
    brithDateFromStorage = value;
    _setData();
  }

  static setOrganizationId(String value) {
    organizationIdFromStorage = value;
    _setData();
  }

    static setBalance(double value) {
      balanceFromStorage = value;
      _setData();
    }

    static setCReduction(double value) {
      cReductionFromStorage = value;
      _setData();
    }

    static setDetection(double value) {
      detectionFromStorage = value;
      _setData();
    }

    static setSuspendedBalance(double value) {
      suspendedBalanceFromStorage = value;
      _setData();
    }

    static setFolderNum(String value) {
      folderNumFromStorage = value;
      _setData();
    }

    static setCity(String value) {
      cityFromStorage = value;
      _setData();
    }

    static setUid(String value) {
      uIdFromStorage = value;
      _setData();
    }

    static setNewOccasion(String value) {
      newOccasion = value;
      _setData();
    }
    static setGiftType(String value) {
      giftType = value;
      _setData();
    }

    static setOccasionDate(String value) {
      occasionDate = value;
      _setData();
    }

    static setMoneyGiftAmount(String value) {
      moneyGiftAmount = value;
      _setData();
    }

    static setOccasionName(String value) {
      occasionName = value;
      _setData();
    }

    static setGiftName(String value) {
      giftName = value;
      _setData();
    }

    static setLink(String value) {
      link = value;
      _setData();
    }

    static setGiftAmount(String value) {
      giftAmount = value;
      _setData();
    }
  static setIsForMe(bool value) {
    isForMe = value;
    _setData();
  }

    /// this function to remove all storage
    static removeAllDataFromStorage() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    /// this function to remove any data from local storage by key
    static removeDataFromStorage(String key) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }

    //#region private
    static _setData() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("userIsGuest", userIsGuest);
      prefs.setBool("userIsLogin", userIsLogin);
      prefs.setBool("firstTime", firstTime);
      prefs.setBool("themeIsDarkMode", themeIsDarkMode);
      prefs.setBool("onBoardingIsOpen", onBoardingIsOpen);
      prefs.setBool("cameraFrontFromStorage", cameraFrontFromStorage);
      prefs.setBool("emailNotFound", emailNotFound);
      prefs.setBool("attendenceAdminFromStorage", attendenceAdminFromStorage);
      prefs.setBool("gradeAdminFromStorage", gradeAdminFromStorage);
      prefs.setString("languageCodeFromStorage", languageCodeFromStorage);
      prefs.setString("languageNameFromStorage", languageNameFromStorage);

      prefs.setString("fullNameFromStorage", fullNameFromStorage);
      prefs.setString("emailFromStorage", emailFromStorage);
      prefs.setString("adminUidFromStorage", adminUidFromStorage);
      prefs.setString("adminNameFromStorage", adminNameFromStorage);
      prefs.setString("phoneNumberFromStorage", phoneNumberFromStorage);
      prefs.setString("countryFromStorage", countryFromStorage);
      prefs.setString("mainGroupFromStorage", mainGroupFromStorage);
      prefs.setString("macAddressFromStorage", macAddressFromStorage);
      prefs.setString("subGroupFromStorage", subGroupFromStorage);
      prefs.setString("userNameFromStorage", userNameFromStorage);
      prefs.setString("organizationIdFromStorage", organizationIdFromStorage);
      prefs.setString("folderNumFromStorage", folderNumFromStorage);
      prefs.setString("cityFromStorage", cityFromStorage);
      prefs.setString("uIdFromStorage", uIdFromStorage);
      prefs.setDouble("cReductionFromStorage", cReductionFromStorage);
      prefs.setDouble("balanceFromStorage", balanceFromStorage);
      prefs.setDouble("detectionFromStorage", detectionFromStorage);
      prefs.setDouble(
          "suspendedBalanceFromStorage", suspendedBalanceFromStorage);
      prefs.setString("fullNameFromStorage", fullNameFromStorage);
      prefs.setString("emailFromStorage", emailFromStorage);
      prefs.setString("adminUidFromStorage", adminUidFromStorage);
      prefs.setString("adminNameFromStorage", adminNameFromStorage);
      prefs.setString("phoneNumberFromStorage", phoneNumberFromStorage);
      prefs.setString("countryFromStorage", countryFromStorage);
      prefs.setString("mainGroupFromStorage", mainGroupFromStorage);
      prefs.setString("genderFromStorage", genderFromStorage);
      prefs.setString("brithDateFromStorage", brithDateFromStorage);
      prefs.setString("macAddressFromStorage", macAddressFromStorage);
      prefs.setString("subGroupFromStorage", subGroupFromStorage);
      prefs.setString("userNameFromStorage", userNameFromStorage);
      prefs.setString("organizationIdFromStorage", organizationIdFromStorage);
      prefs.setString("folderNumFromStorage", folderNumFromStorage);
      prefs.setString("cityFromStorage", cityFromStorage);
      prefs.setString("uIdFromStorage", uIdFromStorage);
      prefs.setDouble("cReductionFromStorage", cReductionFromStorage);
      prefs.setDouble("balanceFromStorage", balanceFromStorage);
      prefs.setDouble("detectionFromStorage", detectionFromStorage);
      prefs.setDouble(
          "suspendedBalanceFromStorage", suspendedBalanceFromStorage);

      prefs.setString("occasionDate", occasionDate);
      prefs.setString("occasionName", occasionName);
      prefs.setString("moneyGiftAmount", moneyGiftAmount);
      prefs.setString("newOccasion", newOccasion);
      prefs.setString("giftType", giftType);
      prefs.setString("giftName", giftName);
      prefs.setString("link", link);
      prefs.setString("giftAmount", giftAmount);
      prefs.setBool("isForMe", isForMe);
    }

    static getData() async {
      final prefs = await SharedPreferences.getInstance();
      userIsGuest = prefs.getBool("userIsGuest") ?? true;
      userIsLogin = prefs.getBool("userIsLogin") ?? false;
      cameraFrontFromStorage = prefs.getBool("cameraFrontFromStorage") ?? false;
      firstTime = prefs.getBool("firstTime") ?? true;
      themeIsDarkMode = prefs.getBool("themeIsDarkMode") ?? false;
      onBoardingIsOpen = prefs.getBool("onBoardingIsOpen") ?? false;
      emailNotFound = prefs.getBool("emailNotFound") ?? false;
      attendenceAdminFromStorage =
          prefs.getBool("attendenceAdminFromStorage") ?? false;
      gradeAdminFromStorage = prefs.getBool("gradeAdminFromStorage") ?? false;
      languageCodeFromStorage =
          prefs.getString("languageCodeFromStorage") ?? 'ar';
      languageNameFromStorage =
          prefs.getString("languageNameFromStorage") ?? 'langArabic';
      userPhoneTypeFromStorage =
          prefs.getString("userPhoneTypeFromStorage") ?? '';

      fullNameFromStorage = prefs.getString("fullNameFromStorage") ?? '';
      emailFromStorage = prefs.getString("emailFromStorage") ?? '';
      adminUidFromStorage = prefs.getString("adminUidFromStorage") ?? '';
      adminNameFromStorage = prefs.getString("adminNameFromStorage") ?? '';
      phoneNumberFromStorage = prefs.getString("phoneNumberFromStorage") ?? '';
      countryFromStorage = prefs.getString("countryFromStorage") ?? '';
      mainGroupFromStorage = prefs.getString("mainGroupFromStorage") ?? '';
      subGroupFromStorage = prefs.getString("subGroupFromStorage") ?? '';
      userNameFromStorage = prefs.getString("userNameFromStorage") ?? '';
      organizationIdFromStorage =
          prefs.getString("organizationIdFromStorage") ?? '';
      folderNumFromStorage = prefs.getString("folderNumFromStorage") ?? '';
      cityFromStorage = prefs.getString("cityFromStorage") ?? '';
      macAddressFromStorage = prefs.getString("macAddressFromStorage") ?? '';
      uIdFromStorage = prefs.getString("uIdFromStorage") ?? '';
      cReductionFromStorage = prefs.getDouble("cReductionFromStorage") ?? 0.0;
      balanceFromStorage = prefs.getDouble("balanceFromStorage") ?? 0.0;
      detectionFromStorage = prefs.getDouble("detectionFromStorage") ?? 0.0;
      suspendedBalanceFromStorage =
          prefs.getDouble("suspendedBalanceFromStorage") ?? 0.0;

      occasionDate = prefs.getString("occasionDate") ?? '';
      occasionName = prefs.getString("occasionName") ?? '';
      moneyGiftAmount = prefs.getString("moneyGiftAmount") ?? '';
      newOccasion = prefs.getString("newOccasion") ?? '';
      giftType = prefs.getString("giftType") ?? '';
      giftName = prefs.getString("giftName") ?? '';
      link = prefs.getString("link") ?? '';
      giftAmount = prefs.getString("giftAmount") ?? '';
      fullNameFromStorage = prefs.getString("fullNameFromStorage") ?? '';
      emailFromStorage = prefs.getString("emailFromStorage") ?? '';
      adminUidFromStorage = prefs.getString("adminUidFromStorage") ?? '';
      adminNameFromStorage = prefs.getString("adminNameFromStorage") ?? '';
      phoneNumberFromStorage = prefs.getString("phoneNumberFromStorage") ?? '';
      countryFromStorage = prefs.getString("countryFromStorage") ?? '';
      mainGroupFromStorage = prefs.getString("mainGroupFromStorage") ?? '';
      subGroupFromStorage = prefs.getString("subGroupFromStorage") ?? '';
      userNameFromStorage = prefs.getString("userNameFromStorage") ?? '';
      organizationIdFromStorage =
          prefs.getString("organizationIdFromStorage") ?? '';
      folderNumFromStorage = prefs.getString("folderNumFromStorage") ?? '';
      cityFromStorage = prefs.getString("cityFromStorage") ?? '';
      macAddressFromStorage = prefs.getString("macAddressFromStorage") ?? '';
      uIdFromStorage = prefs.getString("uIdFromStorage") ?? '';
      brithDateFromStorage = prefs.getString("brithDateFromStorage") ?? '';
      genderFromStorage = prefs.getString("genderFromStorage") ?? '';
      cReductionFromStorage = prefs.getDouble("cReductionFromStorage") ?? 0.0;
      balanceFromStorage = prefs.getDouble("balanceFromStorage") ?? 0.0;
      detectionFromStorage = prefs.getDouble("detectionFromStorage") ?? 0.0;
      suspendedBalanceFromStorage =
          prefs.getDouble("suspendedBalanceFromStorage") ?? 0.0;
      isForMe = prefs.getBool("isForMe") ?? false;
    }


  }

