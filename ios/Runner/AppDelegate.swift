import Flutter
import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import cloud_firestore
import UserNotifications
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate , MessagingDelegate{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
    } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Forward the notification to Firebase Auth if it's related
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // Handle other notifications here if needed
        completionHandler(.newData)
  }

      // Handle remote notification registration token refresh
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(fcmToken ?? "")")

      // Here you can send the FCM token to your server or perform any other necessary tasks
  }

  // Handle receiving remote notifications while the app is in the foreground
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
      // Handle notification
      // This method is called when the app receives a remote notification while it is running in the foreground
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
  }

  // Handle user tapping on the notification banner while the app is in the foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      var presentationOptions: UNNotificationPresentationOptions = []

      if #available(iOS 14.0, *) {
          presentationOptions.insert(.banner)
      }

      presentationOptions.insert([.sound, .badge]) // Always include sound and badge options

      completionHandler(presentationOptions)
  }
}
