import Flutter
import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import FirebaseMessaging
import GoogleSignIn
import FirebaseDynamicLinks

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  // Method channel for dynamic links
  private var dynamicLinksChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase configuration
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)

    // Set up method channel for communicating dynamic link data to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      dynamicLinksChannel = FlutterMethodChannel(
          name: "app/dynamic_links",
          binaryMessenger: controller.binaryMessenger)

      // Check for Firebase Dynamic Links at app launch
      DynamicLinks.dynamicLinks().getInitialLink { [weak self] (dynamicLink, error) in
        guard let self = self else { return }
        if let dynamicLink = dynamicLink {
          print("Initial dynamic link detected at app launch: \(dynamicLink.url?.absoluteString ?? "nil")")
          self.handleIncomingDynamicLink(dynamicLink.url, channel: self.dynamicLinksChannel)
        }
      }
    }

    // Configure notifications
    if #available(iOS 10.0, ) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { _, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
      UIApplication.shared.registerForRemoteNotifications()
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle URL schemes for Google Sign-In and Dynamic Links
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    print("AppDelegate received open URL: \(url.absoluteString)")

    // First check if it's a Google Sign-In URL
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }

    // Handle Dynamic Links
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
      print("Processing dynamic link from custom scheme: \(url.absoluteString)")
      handleIncomingDynamicLink(dynamicLink.url, channel: dynamicLinksChannel)
      return true
    }

    // Handle custom scheme for Hadawi app directly
    if url.scheme == "hadawi" || url.scheme == "com.app.hadawiapp" {
      print("Processing Hadawi custom URL scheme: \(url.absoluteString)")
      handleIncomingDynamicLink(url, channel: dynamicLinksChannel)
      return true
    }

    return false
  }

  // This handles Universal Links when the app is already running
  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    print("AppDelegate continuing user activity: \(userActivity.activityType)")

    if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL {
      print("Processing universal link: \(incomingURL.absoluteString)")

      // Let Firebase handle the Universal Link
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { [weak self] (dynamicLink, error) in
        guard let self = self else { return }

        if let dynamicLink = dynamicLink {
          print("Successfully processed universal link to dynamic link: \(dynamicLink.url?.absoluteString ?? "nil")")
          self.handleIncomingDynamicLink(dynamicLink.url, channel: self.dynamicLinksChannel)
        } else if let error = error {
          print("Error handling universal link: \(error.localizedDescription)")
        }
      }

      return handled
    }

    return false
  }

  // Process dynamic link and send data to Flutter
  private func handleIncomingDynamicLink(_ url: URL?, channel: FlutterMethodChannel?) {
    guard let url = url, let channel = channel else {
      print("Cannot handle dynamic link: URL or channel is nil")
      return
    }

    let linkString = url.absoluteString
    print("Hadawi app processing dynamic link: \(linkString)")

    // Parse parameters from the URL
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
      var params = [String: String]()

      // Extract query parameters
      if let queryItems = components.queryItems {
        for item in queryItems {
          params[item.name] = item.value
        }
      }

      // Extract path components
      let pathComponents = url.pathComponents.filter { $0 != "/" }

      // Special handling for hadawiapp.page.link domain
      if url.host == "hadawiapp.page.link" {
        print("Handling official Hadawi Firebase Dynamic Link")
      }

      // Send the data to Flutter through the method channel
      channel.invokeMethod("dynamicLinkReceived", arguments: [
        "url": linkString,
        "path": pathComponents,
        "params": params,
        "scheme": url.scheme ?? "",
        "host": url.host ?? ""
      ])

      print("Sent dynamic link data to Flutter")
    } else {
      // If we can't parse components, just send the raw URL
      channel.invokeMethod("dynamicLinkReceived", arguments: [
        "url": linkString,
        "scheme": url.scheme ?? ""
      ])

      print("Sent basic dynamic link data to Flutter (couldn't parse components)")
    }
  }

  // MARK: - Notification Handling

  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Check if the notification contains a dynamic link
    if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
      print("Detected dynamic link in push notification: \(urlString)")
      handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
    }

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
  }

  // Handle receiving remote notifications while the app is in the foreground
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // Check if notification contains a dynamic link
    if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
      print("Detected dynamic link in foreground notification: \(urlString)")
      handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
    }
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  // Handle user tapping on the notification banner while the app is in the foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // Check if notification contains a dynamic link
    if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
      print("Detected dynamic link in notification being presented: \(urlString)")
      handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
    }

    var presentationOptions: UNNotificationPresentationOptions = []

    if #available(iOS 14.0, *) {
      presentationOptions.insert(.banner)
    }

    presentationOptions.insert([.sound, .badge])

    completionHandler(presentationOptions)
  }

  // Handle notification response (when user taps a notification)
  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // Check if notification contains a dynamic link
    if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
      print("Processing dynamic link from notification response: \(urlString)")
      handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
    }

    completionHandler()
  }
}