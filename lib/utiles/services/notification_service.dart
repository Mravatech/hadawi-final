import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/local_notification_services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:dio/dio.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
class NotificationService{

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initRemoteNotification()async{
    await messaging.requestPermission();
    handleBackgroundMessage();
    handleLiveMessage();
  }

  // handle notification when receive
  Future<void>handleMessage(RemoteMessage? message)async{
    if(message ==null)return;
    print('title ${message.notification!.title}');
    print('body ${message.notification!.body}');
  }

  Future<void> handleBackgroundMessage()async{
    FirebaseMessaging.instance.getInitialMessage().then((message) => handleMessage(message));
    FirebaseMessaging.onMessageOpenedApp.listen((message) => handleMessage(message));
  }

  Future<void> handleLiveMessage()async{
    FirebaseMessaging.onMessage.listen((message) {
      handleMessage(message);
      LocalNotificationServices.init();
      LocalNotificationServices.showBasicNotification(title: message.notification!.title!, body: message.notification!.body!);
    });

  }


  // Future<String?> getAccessToken() async {
  //   final serviceAccountJson = {
  //     "type": "service_account",
  //     "project_id": "transport-app-d662f",
  //     "private_key_id": "e0a83419c447e3fef318a5dbbda9e7eaa689ed26",
  //     "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDcOsJknwgbVRL1\nUdMdtgZyK+rjokC5NHbQik6i8V6KrEAkatnYKmMYBze5A2cfvBvR/N8K8yQG7p4E\ncSvIP0NGl8jpS9wNjrTTF0R2fNoXnG+Iy+FRgB1ZSD+kOJv1eNMXU2YM0Sfc/FCN\nMQZ2/l+iENdU6j5x/OHOcziryB7X2mBVxJt/K0bBItfzcqt3fo258os4ZXsJUkbU\nW4sHF3fHr9ZHTUltZDXwgpdyfmAjTR+k3GB2dkptZsmWCP+uFs08XpSr5PNk5ohu\nVhTttD47+fezJQzSRbvPHgGkV05E8ktakLYNbhlrFm28pJVpBQexJEE86xORDqF+\nwSMrB3l3AgMBAAECggEATBpGCK1oCMHqTjnbYX4AVj3U6pqsERQPJttUdzw/dl41\nwB/obamgGrKLz/RcE3xWhMcEcG06+uZEVrag8Y7i+acD95KOVWUGGZgFwYg9eUFG\nzZfeoeJKwgqUa3RgeIArOflI3477XoMWduQFHuOiOoflUWOs9ojzovrwD3SVK/OX\nPpNEDUUSBvO6D05mbHsM5PjCwoeVHqkp6qYAdQ39u93Z89g5ckHW2y2UOr6cuTj2\nSkIzfnonTXiRZ+hOMXV9phrEEkXj2034RS4ckJzORpWj2aDnkt8VL5LYshYc9tah\n/f9wkthHIQm7Bk3kAul1uVDiyXBwJMiMaLbNkzOJ4QKBgQDe7tSgJ759O+nvmpVp\nW+2WhonmExp4YcAi4RD7K3nFJWJNtb6ZbcIpQScuUyA6UHAhV/72E8x0c/X1e3b1\nunoEjrOLz1R4sOdUQdEHfPS/KplaVbdJoR78Q8rU9vVYdjcHtvZY17W7XwDIMIUv\nvGx1RZu8LqipS5G0jJkVeF6LJwKBgQD85UaQEo9ftD/ZG+ts05mhqexLLKjHx+5I\nk8NAtQfYEv8TMSqzc75jIDuv7Tmv8r5u3LxX0/d2Xrmx7Tjty9OBRqxgtxqFeTrQ\ncAuJxoG4v1WfVCxyM6/0YfamGtRVLedfwZCXTw3QZOatm04FtMNt42eObEhu+5BV\nDVcKaIzRMQKBgQCCmxNQnNg50G8WY88jAato43tIomqAmmwRQyBKtkbJ3EQCWPbI\nNoho2PXWavbXkyaOMlp52lGO7Bzt655fChfQMbY4s4e+iY2NTF3k8C0HDjL3vH38\nEfvwONtM9z33zJIi3+rlU8LxehAgOGTe+Znk/pnlnsRLIq3DRBevf2yMQwKBgQD4\nBpks5bcNwsc31EUR53lubyvbEoK55SCSt7CwPpvh08es9/SMKUEZENzZDs0b/fO8\n4OorLS0vP3nZwfGqbtQRntGizRHKw/nlwW3fgvtoyOZdq/0nSAASqx1vDTMgEzQv\n2rRHYXYH413F+GIOAJoGpRfEO/jSOBD3CW1LPPyWkQKBgQCsA5ZZlEm8PR78ZzX7\nLvPBiCQLBknq8e6rNVHMOlJK5UK3KF8zZhXWmIeitKuIedY2xXMl6ByAMy8eK6Bd\ndPTASJloaE5oM5jnMNyZjnguI6qtF/PxzyOEBi2m8NzKJNxZHtTb8LQqf7iKOZUV\nzd2PGtJt2SECehLbw3o8WM3MEg==\n-----END PRIVATE KEY-----\n",
  //     "client_email": "firebase-adminsdk-mwwf2@transport-app-d662f.iam.gserviceaccount.com",
  //     "client_id": "104445999927303610295",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mwwf2%40transport-app-d662f.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   };
  //
  //   List<String> scopes = [
  //     "https://www.googleapis.com/auth/userinfo.email",
  //     "https://www.googleapis.com/auth/firebase.database",
  //     "https://www.googleapis.com/auth/firebase.messaging"
  //   ];
  //
  //   try {
  //     http.Client client = await auth.clientViaServiceAccount(
  //         auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
  //
  //     auth.AccessCredentials credentials =
  //     await auth.obtainAccessCredentialsViaServiceAccount(
  //         auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  //         scopes,
  //         client);
  //
  //     client.close();
  //     print(
  //         "Access Token: ${credentials.accessToken.data}"); // Print Access Token
  //     return credentials.accessToken.data;
  //   } catch (e) {
  //     print("Error getting access token: $e");
  //     return null;
  //   }
  // }
  //
  //
  // Future<void> sendNotifications({
  //   required String fcmToken,
  //   required String title,
  //   required String body,
  //   required String userId,
  //   String? type,
  // }) async {
  //   try {
  //     var serverKeyAuthorization = await getAccessToken();
  //
  //     // change your project id
  //     const String urlEndPoint =
  //         "https://fcm.googleapis.com/v1/projects/transport-app-d662f/messages:send";
  //
  //
  //     Dio dio = Dio();
  //     dio.options.headers['Content-Type'] = 'application/json';
  //     dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';
  //
  //     var response = await dio.post(
  //       urlEndPoint,
  //       data: {
  //           "message": {
  //             "token": "cxKma7_0SciOIcQ3wWNF41:APA91bEOso3mv9T1nJeC496Tlf5VqeaEHowYsoTmyTyBWrnbyf--nH6UKJxWpgJSweRQrWr8FMniCDhh-lQ9o-s9uWoEYa3MMhj4crEcntj3GiIJCC2DkMI",
  //             "notification": {"title": "رمضان كريم", "body": "كل عام وانتم بخير"},
  //             "android": {
  //               "notification": {
  //                 "notification_priority": "PRIORITY_MAX",
  //                 "sound": "default"
  //               }
  //             },
  //             "apns": {
  //               "payload": {
  //                 "aps": {"content_available": true}
  //               }
  //             },
  //             "data": {
  //               "type": "",
  //               "id": "l1gimdGsKHa8d2WBsiwvqHSlt7N2",
  //               "click_action": "FLUTTER_NOTIFICATION_CLICK"
  //             }
  //           }
  //         }
  //     );
  //
  //     // Print response status code and body for debugging
  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Data: ${response.data}');
  //   } catch (e) {
  //     print("Error sending notification: $e");
  //   }
  // }


}