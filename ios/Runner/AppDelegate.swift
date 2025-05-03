import UIKit
import Flutter
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseDynamicLinks
import GoogleSignIn
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var dynamicLinksChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        GeneratedPluginRegistrant.register(with: self)

        // Set up the dynamic links channel
        if let controller = window?.rootViewController as? FlutterViewController {
            dynamicLinksChannel = FlutterMethodChannel(
                name: "app/dynamic_links",
                binaryMessenger: controller.binaryMessenger
            )

            // Check for initial dynamic link
            if let url = launchOptions?[.url] as? URL {
                self.handleIncomingDynamicLink(url, channel: self.dynamicLinksChannel)
            } else {
                self.checkForInitialDynamicLink()
            }
        }

        // Handle push notifications
        self.setupNotifications(application)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func checkForInitialDynamicLink() {
        DynamicLinks.dynamicLinks().resolveInitialLink(completion: { dynamicLink, error in
            if let url = dynamicLink?.url {
                print("Initial dynamic link detected: \(url.absoluteString)")
                self.handleIncomingDynamicLink(url, channel: self.dynamicLinksChannel)
            }
        })
    }

    private func setupNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("AppDelegate received open URL: \(url.absoluteString)")

        // Google SignIn handling
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }

        // Handle dynamic links
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            print("Processing dynamic link from custom scheme: \(url.absoluteString)")
            handleIncomingDynamicLink(dynamicLink.url, channel: dynamicLinksChannel)
            return true
        }

        // Handle custom URL scheme
        if url.scheme == "hadawi" || url.scheme == "com.app.hadawiapp" {
            print("Processing Hadawi custom URL scheme: \(url.absoluteString)")
            handleIncomingDynamicLink(url, channel: dynamicLinksChannel)
            return true
        }

        return false
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL {
            print("Processing universal link: \(incomingURL.absoluteString)")

            return DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                if let url = dynamicLink?.url {
                    print("Successfully processed universal link: \(url.absoluteString)")
                    self.handleIncomingDynamicLink(url, channel: self.dynamicLinksChannel)
                }
            }
        }

        return false
    }

    private func handleIncomingDynamicLink(_ url: URL?, channel: FlutterMethodChannel?) {
        guard let url = url, let channel = channel else {
            print("Cannot handle dynamic link: URL or channel is nil")
            return
        }

        let linkString = url.absoluteString
        print("Processing dynamic link: \(linkString)")

        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var params = [String: String]()

            if let queryItems = components.queryItems {
                for item in queryItems {
                    params[item.name] = item.value ?? ""
                }
            }

            let pathComponents = url.pathComponents.filter { $0 != "/" }

            channel.invokeMethod("dynamicLinkReceived", arguments: [
                "url": linkString,
                "path": pathComponents,
                "params": params,
                "scheme": url.scheme ?? "",
                "host": url.host ?? ""
            ])

            print("Sent dynamic link data to Flutter")
        } else {
            channel.invokeMethod("dynamicLinkReceived", arguments: [
                "url": linkString,
                "scheme": url.scheme ?? ""
            ])

            print("Sent basic dynamic link data to Flutter")
        }
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
            print("Detected dynamic link in push notification: \(urlString)")
            handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
        }

        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }

        completionHandler(.newData)
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
            print("Detected dynamic link in foreground notification: \(urlString)")
            handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
        }
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
            print("Detected dynamic link in notification being presented: \(urlString)")
            handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
        }

        let presentationOptions: UNNotificationPresentationOptions
        if #available(iOS 14.0, *) {
            presentationOptions = [.banner, .sound, .badge]
        } else {
            presentationOptions = [.alert, .sound, .badge]
        }

        completionHandler(presentationOptions)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let urlString = userInfo["dynamic_link"] as? String, let linkUrl = URL(string: urlString) {
            print("Processing dynamic link from notification response: \(urlString)")
            handleIncomingDynamicLink(linkUrl, channel: dynamicLinksChannel)
        }

        completionHandler()
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
    }
}